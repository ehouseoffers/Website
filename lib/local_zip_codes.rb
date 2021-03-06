module LocalZipCodes
  LOCAL_ZIP_CODES = [
    98499, #	Pierce
    98498, #	Pierce
    98497, #	Pierce
    98496, #	Pierce
    98493, #	Pierce
    98490, #	Pierce
    98481, #	Pierce
    98471, #	Pierce
    98467, #	Pierce
    98466, #	Pierce
    98465, #	Pierce
    98464, #	Pierce
    98448, #	Pierce
    98447, #	Pierce
    98446, #	Pierce
    98445, #	Pierce
    98444, #	Pierce
    98443, #	Pierce
    98439, #	Pierce
    98438, #	Pierce
    98433, #	Pierce
    98431, #	Pierce
    98430, #	Pierce
    98424, #	Pierce
    98422, #	Pierce
    98421, #	Pierce
    98419, #	Pierce
    98418, #	Pierce
    98417, #	Pierce
    98416, #	Pierce
    98415, #	Pierce
    98413, #	Pierce
    98412, #	Pierce
    98411, #	Pierce
    98409, #	Pierce
    98408, #	Pierce
    98407, #	Pierce
    98406, #	Pierce
    98405, #	Pierce
    98404, #	Pierce
    98403, #	Pierce
    98402, #	Pierce
    98401, #	Pierce
    98337, #	Kitsap
    98337, #	Kitsap
    98314, #	Kitsap
    98314, #	Kitsap
    98312, #	Kitsap
    98312, #	Kitsap
    98311, #	Kitsap
    98311, #	Kitsap
    98310, #	Kitsap
    98310, #	Kitsap
    98296, #	Snohomish
    98291, #	Snohomish
    98290, #	Snohomish
    98199, #	King
    98198, #	King
    98195, #	King
    98194, #	King
    98191, #	King
    98190, #	King
    98189, #	King
    98188, #	King
    98185, #	King
    98181, #	King
    98178, #	King
    98177, #	King
    98175, #	King
    98174, #	King
    98170, #	King
    98168, #	King
    98166, #	King
    98165, #	King
    98164, #	King
    98161, #	King
    98160, #	King
    98158, #	King
    98155, #	King
    98154, #	King
    98148, #	King
    98146, #	King
    98145, #	King
    98144, #	King
    98141, #	King
    98139, #	King
    98138, #	King
    98136, #	King
    98134, #	King
    98133, #	King
    98132, #	King
    98131, #	King
    98129, #	King
    98127, #	King
    98126, #	King
    98125, #	King
    98124, #	King
    98122, #	King
    98121, #	King
    98119, #	King
    98118, #	King
    98117, #	King
    98116, #	King
    98115, #	King
    98114, #	King
    98113, #	King
    98112, #	King
    98111, #	King
    98110, #	Kitsap
    98109, #	King
    98108, #	King
    98107, #	King
    98106, #	King
    98105, #	King
    98104, #	King
    98103, #	King
    98102, #	King
    98101, #	King
    98225, #	Whatcom
    98226, #	Whatcom
    98227, #	Whatcom
    98228, #	Whatcom
    98229, #	Whatcom
    98528, #	Mason
    98273, #	Skagit
    98273 #	Skagit
  ]
  
  def self.local?(zip)
    LOCAL_ZIP_CODES.include?(zip)
  end

end