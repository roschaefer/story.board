module Text
  class Sorter
    def self.sort(text_components)
      components = text_components.clone
      components = components.shuffle
      nil_priorities, components = components.partition {|c| c.priority.nil? }
      components = components.sort_by(&:priority_index)
      components = components.reverse
      components = components + nil_priorities
    end
  end
end
