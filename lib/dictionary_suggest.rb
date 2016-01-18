class DictionarySuggest
  include DidYouMean::SpellCheckable

  module Suggestable
    def suggests_with(method_name)
      self.class_eval %Q{
        def to_s
          send(:#{method_name})
        end
      }
    end
  end

  attr_reader :dictionary, :last_query

  def initialize(dictionary)
    @dictionary = dictionary
  end

  def matches(query)
    clear_suggestions! if @last_query != query
    @last_query = query
    corrections
  end

  def clear_suggestions!
    @corrections = nil
  end

  def candidates
    {last_query => dictionary}
  end

end
