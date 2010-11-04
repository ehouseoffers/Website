# Monkey-patching String
class String
  def make_url_friendly  
    # 1. Downcase string
    # 2. Remove apostrophes so isn't changes to isnt
    # 3. Replace any non-letter or non-number character with a space
    # 4. Remove spaces from beginning and end of string
    # 5. Replace groups of spaces with single hyphen
    self.downcase.gsub(/'/, '').gsub(/[^A-Za-z0-9]+/, ' ').strip.gsub(/\ +/, '-')
  end

  # Stepping all over the native truncate()
  def truncate(length = 100, truncate_string = "...")
    # First regex truncates to the length, plus the rest of that word, if any.
    # Second regex removes any trailing whitespace or punctuation (except ;).
    # Unlike the regular truncate method, this avoids the problem with cutting
    # in the middle of an entity ex.: truncate("this &amp; that",9)  => "this &am..."
    # though it will not be the exact length.

    return if self.blank?
    l = length - truncate_string.length
    self.length > length ? self[/\A.{#{l}}\w*\;?/m][/.*[\w\;]/m] + truncate_string : self
  end

  def strip_html
    self.gsub(%r{</?[^>]+?>}, '')
  end
end 

