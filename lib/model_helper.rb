module ModelHelper
  # Convenient way to get an object of the correct class whether passed an object, id, or string
  # qa = ModelHelper.object_for(1,Qa)    # will return <Qa id:1, ...> object
  def self.object_for(what, klass, *klasses)
    klass = klass.kind_of?(String) ? eval(klass) : klass
    return what if what.kind_of?(klass) || klasses.any? {|klassy| what.kind_of?(klassy)}
    id = normalize_id(what, klass)
    klass.find_by_id(id) if id
  end

  # Convenient way to make sure we get an ID whether we're passed an int, string, or object
  def self.normalize_id(what, klass = nil)
    return nil if what.blank?
    return what if what.kind_of?(Integer)
    return what.to_i if what.kind_of?(String)
    raise "Can't make a #{what.class} into a #{klass}" if !Rails.env.production? && klass && !what.kind_of?(klass)
    what.id
  end
end