module Text
  class Sorter
    def self.sort(components, opts)
      components = components.select {|c| c.active?(opts) }
      components = components.shuffle
      nil_priorities, components = components.partition {|c| c.priority.nil? }
      components = components.sort_by(&:priority_index)
      components = components.reverse
      components = components + nil_priorities
    end
  end
end
