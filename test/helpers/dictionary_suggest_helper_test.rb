require 'test_helper'
require './lib/dictionary_suggest'
class DictionarySuggestHelperTest < ActiveSupport::TestCase

  test 'a dictionary can provide suggestions' do

    dictionary = ['apple','banana','bandana','sausages']

    suggester = DictionarySuggest.new(dictionary)

    assert_equal ['apple'], suggester.matches('appfle')
    assert_equal ['apple'], suggester.matches('apple')
    assert_equal ['banana','bandana'], suggester.matches('bannana')
  end

  test 'a dictionary can use params if provided with a rails model' do

    apple = create :dashboard, name: 'apple', key: 'apple'
    banana = create :dashboard, name: 'banana', key: 'banana'
    bandana = create :dashboard, name: 'bandana', key: 'bandana'
    sausages = create :dashboard, name: 'sausages', key: 'sausages'

    dictionary = [apple,banana,bandana,sausages]
    suggester = DictionarySuggest.new(dictionary)

    assert_equal [apple], suggester.matches('appfle')
    assert_equal [apple], suggester.matches('apple')
    assert_equal [banana,bandana], suggester.matches('bannana')
  end
end
