# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format (all these examples are active by default):
ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural 'reason_to_sell', 'reasons_to_sell'
  inflect.singular 'reasons_to_sell', 'reason_to_sell'

  inflect.plural 'spotlight', 'spotlighters'
  inflect.singular 'spotlighters', 'spotlight'

  # inflect.plural /^(ox)$/i, '\1en'
  # inflect.singular /^(ox)en/i, '\1'
  # inflect.irregular 'person', 'people'
  # inflect.uncountable %w( fish sheep )
end
