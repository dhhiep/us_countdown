# frozen_string_literal: true

module ApplicationHelper
  def visa_bulletin_loop(resource = VisaBulletin.all)
    all = resource.to_a
    current = all.shift
    previous = all.shift

    while current
      yield(current, previous)
      current = previous
      previous = all.shift
    end
  end
end
