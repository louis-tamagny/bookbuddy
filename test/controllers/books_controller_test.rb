require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  test "try create book from BNF" do
    post books_path, params: {book: {isbn: "9791028120863" }}
    
    assert true
  end
end
