class Publication
  include Mongoid::Document

  field :name,            :type => String
  field :section,         :type => String
  field :body,            :type => String
  field :is_published,    :type => Boolean
end

class LongerPublication < Publication
  field :extra_body,      :type => String
end