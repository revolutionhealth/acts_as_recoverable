require File.join(File.dirname(__FILE__), 'test_helper')

class ActsAsRecoverableTest < Test::Unit::TestCase
  
  def teardown
    [Tag, Article, Comment, RecoverableObject, Rating, Comment, Listing, Location].each do |klass| 
      klass.all.each { |a| a.destroy }
    end
  end
  
  def test_factories
    a = article(2, :name => 'hackery')
    a.save
    a.reload
    assert_equal 2, a.comments.size
  end
  
  def test_should_be_removed_from_finds_when_destroyed
    a = article(2, :name => 'hack1')
    a.destroy
    assert_nil Article.find_by_name('hack1')
    assert_nil Comment.find_by_content('c1')
  end

  def test_should_be_added_to_recoverable_objects_when_destroyed
    a = article(0, :name => 'oooh')
    a.destroy
    assert_equal 1, RecoverableObject.all.size
  end

  def test_should_not_be_added_to_recoverable_objects_when_destroyed!
    a = article(0, :name => 'gone for good')
    a.destroy!
    assert_equal 0, RecoverableObject.count
  end
  
  def test_should_recover_objects_using_finder_class_method
    #create two articles, with one comment and one rating
    article_one = article(0, :name => 'article one')
    article_one_id = article_one.id
    article_two = article(0, :name => 'article two')
    article_two_id = article_two.id
    
    comment_one = comment()
    rating_one = rating()
    comment_one.ratings << rating_one
    
    comment_two = comment()
    rating_two = rating()
    comment_two.ratings << rating_two
    
    article_one.comments << comment_one
    article_two.comments << comment_two    
    
    #check to see that there are 2 articles, comments, and ratings
    assert_equal 2, Article.count
    assert_equal 2, Comment.count
    assert_equal 2, Rating.count
    
    assert_equal 1, article_one.reload.comments.size
    
    #destroy the first article
    article_one.destroy
    
    #assert that there is one recoverable in the recoverable_objects
    assert_equal 1, RecoverableObject.count
    
    #assert that one article, one comment, and one rating did get deleted
    assert_equal 1, Article.count
    assert_equal 1, Comment.count
    assert_equal 1, Rating.count
    
    #add a Tag to the second article. Tag also acts_as_recoverable.
    article_two.tags << Tag.create(:name => "My First Tag")
    assert_equal 1, Article.count
    assert_equal 1, Comment.count
    assert_equal 1, Rating.count
    assert_equal 1, Tag.count
    
    #destroy the second article
    article_two.destroy
    
    #assert there are no articles and tags
    assert_equal 0, Article.count
    assert_equal 0, Tag.count

    #assert there are 3 recoverable records, two articles and one tag
    assert_equal 3, RecoverableObject.count
    types = RecoverableObject.find(:all).collect {|obj|obj.recoverable_type}
    assert_equal ["Article", "Article", "Tag"], types
    
    #Try to recover the first article
    Article.find_and_recover(article_one_id)
    
    #Make sure that one article was restored
    assert_equal 1, Article.count
    assert_equal 1, Comment.count
    assert_equal 1, Rating.count
    
    assert_equal 2, RecoverableObject.count
    
    #Make sure that the restored article's id is equal to the original id of the article
    assert Article.find(article_one_id)
    assert Article.find(:first).id, Article.find(article_one_id).id

    #Recover the second article
    Article.find_and_recover(article_two_id)
    assert Article.find(article_two_id)
    
    #Make sure both articles, comments, and ratings are restored
    assert_equal 2, Article.count
    assert_equal 2, Comment.count
    assert_equal 2, Rating.count
    assert_equal 1, Tag.count    
    
    #The Tag recoverable should still be in the table since we didn't explicitly recover it
    assert_equal 1, RecoverableObject.count
    assert_equal "Tag", RecoverableObject.find(:first).recoverable_type
  end
  
  def test_should_restore_the_same_id_and_timestamps
    article_one = article(0, :name => 'article one')
    article_one_id = article_one.id
    
    article_one.name = "article one change"
    article_one.save
    
    updated_at = article_one.updated_at
    created_at = article_one.created_at

    article_one.destroy
    
    article = Article.find_and_recover(article_one_id)
    assert article
    assert_equal article_one_id, article.id
    assert_equal updated_at.to_s, article.updated_at.to_s
    assert_equal created_at.to_s, article.created_at.to_s
  end
  
  def test_should_work_with_sti
    health = HealthArticle.create(:name => "Health Article")
    health_id = health.id
    technical = TechnicalArticle.create(:name => "Technical Article")
    
    health.destroy
    technical.destroy
    
    assert RecoverableObject.find(:first).deleted_at
    
    health = HealthArticle.find_and_recover(health_id)
    assert health
  end
  
end
