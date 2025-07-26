enum Currency: String, CaseIterable, Codable {
    case aed
    case afn
    case all
    case amd
    case ang
    case aoa
    case ars
    case aud
    case awg
    case azn
    case bam
    case bbd
    case bdt
    case bgn
    case bhd
    case bif
    case bmd
    case bnd
    case bob
    case brl
    case bsd
    case btn
    case bwp
    case byn
    case bzd
    case cad
    case cdf
    case chf
    case clp
    case cny
    case cop
    case crc
    case cuc
    case cup
    case cve
    case czk
    case djf
    case dkk
    case dop
    case dzd
    case egp
    case ern
    case etb
    case eur
    case fjd
    case fkp
    case gbp
    case gel
    case ghs
    case gip
    case gmd
    case gnf
    case gtq
    case gyd
    case hkd
    case hnl
    case hrk
    case htg
    case huf
    case idr
    case ils
    case inr
    case iqd
    case irr
    case isk
    case jmd
    case jod
    case jpy
    case kes
    case kgs
    case khr
    case kmf
    case kpw
    case krw
    case kwd
    case kyd
    case kzt
    case lak
    case lbp
    case lkr
    case lrd
    case lsl
    case lyd
    case mad
    case mdl
    case mga
    case mkd
    case mmk
    case mnt
    case mop
    case mru
    case mur
    case mvr
    case mwk
    case mxn
    case myr
    case mzn
    case nad
    case ngn
    case nio
    case nok
    case npr
    case nzd
    case omr
    case pab
    case pen
    case pgk
    case php
    case pkr
    case pln
    case pyg
    case qar
    case ron
    case rsd
    case rub
    case rwf
    case sar
    case sbd
    case scr
    case sdg
    case sek
    case sgd
    case shp
    case sll
    case sos
    case srd
    case ssp
    case stn
    case syp
    case szl
    case thb
    case tjs
    case tmt
    case tnd
    case top
    case `try`
    case ttd
    case twd
    case tzs
    case uah
    case ugx
    case usd
    case uyu
    case uzs
    case ves
    case vnd
    case vuv
    case wst
    case xaf
    case xcd
    case xof
    case xpf
    case yer
    case zar
    case zmw

    var abbreviation: String {
        switch self {
        case .aed:
            "AED"
        case .afn:
            "AFN"
        case .all:
            "ALL"
        case .amd:
            "AMD"
        case .ang:
            "ANG"
        case .aoa:
            "AOA"
        case .ars:
            "ARS"
        case .aud:
            "AUD"
        case .awg:
            "AWG"
        case .azn:
            "AZN"
        case .bam:
            "BAM"
        case .bbd:
            "BBD"
        case .bdt:
            "BDT"
        case .bgn:
            "BGN"
        case .bhd:
            "BHD"
        case .bif:
            "BIF"
        case .bmd:
            "BMD"
        case .bnd:
            "BND"
        case .bob:
            "BOB"
        case .brl:
            "BRL"
        case .bsd:
            "BSD"
        case .btn:
            "BTN"
        case .bwp:
            "BWP"
        case .byn:
            "BYN"
        case .bzd:
            "BZD"
        case .cad:
            "CAD"
        case .cdf:
            "CDF"
        case .chf:
            "CHF"
        case .clp:
            "CLP"
        case .cny:
            "CNY"
        case .cop:
            "COP"
        case .crc:
            "CRC"
        case .cuc:
            "CUC"
        case .cup:
            "CUP"
        case .cve:
            "CVE"
        case .czk:
            "CZK"
        case .djf:
            "DJF"
        case .dkk:
            "DKK"
        case .dop:
            "DOP"
        case .dzd:
            "DZD"
        case .egp:
            "EGP"
        case .ern:
            "ERN"
        case .etb:
            "ETB"
        case .eur:
            "EUR"
        case .fjd:
            "FJD"
        case .fkp:
            "FKP"
        case .gbp:
            "GBP"
        case .gel:
            "GEL"
        case .ghs:
            "GHS"
        case .gip:
            "GIP"
        case .gmd:
            "GMD"
        case .gnf:
            "GNF"
        case .gtq:
            "GTQ"
        case .gyd:
            "GYD"
        case .hkd:
            "HKD"
        case .hnl:
            "HNL"
        case .hrk:
            "HRK"
        case .htg:
            "HTG"
        case .huf:
            "HUF"
        case .idr:
            "IDR"
        case .ils:
            "ILS"
        case .inr:
            "INR"
        case .iqd:
            "IQD"
        case .irr:
            "IRR"
        case .isk:
            "ISK"
        case .jmd:
            "JMD"
        case .jod:
            "JOD"
        case .jpy:
            "JPY"
        case .kes:
            "KES"
        case .kgs:
            "KGS"
        case .khr:
            "KHR"
        case .kmf:
            "KMF"
        case .kpw:
            "KPW"
        case .krw:
            "KRW"
        case .kwd:
            "KWD"
        case .kyd:
            "KYD"
        case .kzt:
            "KZT"
        case .lak:
            "LAK"
        case .lbp:
            "LBP"
        case .lkr:
            "LKR"
        case .lrd:
            "LRD"
        case .lsl:
            "LSL"
        case .lyd:
            "LYD"
        case .mad:
            "MAD"
        case .mdl:
            "MDL"
        case .mga:
            "MGA"
        case .mkd:
            "MKD"
        case .mmk:
            "MMK"
        case .mnt:
            "MNT"
        case .mop:
            "MOP"
        case .mru:
            "MRU"
        case .mur:
            "MUR"
        case .mvr:
            "MVR"
        case .mwk:
            "MWK"
        case .mxn:
            "MXN"
        case .myr:
            "MYR"
        case .mzn:
            "MZN"
        case .nad:
            "NAD"
        case .ngn:
            "NGN"
        case .nio:
            "NIO"
        case .nok:
            "NOK"
        case .npr:
            "NPR"
        case .nzd:
            "NZD"
        case .omr:
            "OMR"
        case .pab:
            "PAB"
        case .pen:
            "PEN"
        case .pgk:
            "PGK"
        case .php:
            "PHP"
        case .pkr:
            "PKR"
        case .pln:
            "PLN"
        case .pyg:
            "PYG"
        case .qar:
            "QAR"
        case .ron:
            "RON"
        case .rsd:
            "RSD"
        case .rub:
            "RUB"
        case .rwf:
            "RWF"
        case .sar:
            "SAR"
        case .sbd:
            "SBD"
        case .scr:
            "SCR"
        case .sdg:
            "SDG"
        case .sek:
            "SEK"
        case .sgd:
            "SGD"
        case .shp:
            "SHP"
        case .sll:
            "SLL"
        case .sos:
            "SOS"
        case .srd:
            "SRD"
        case .ssp:
            "SSP"
        case .stn:
            "STN"
        case .syp:
            "SYP"
        case .szl:
            "SZL"
        case .thb:
            "THB"
        case .tjs:
            "TJS"
        case .tmt:
            "TMT"
        case .tnd:
            "TND"
        case .top:
            "TOP"
        case .try:
            "TRY"
        case .ttd:
            "TTD"
        case .twd:
            "TWD"
        case .tzs:
            "TZS"
        case .uah:
            "UAH"
        case .ugx:
            "UGX"
        case .usd:
            "USD"
        case .uyu:
            "UYU"
        case .uzs:
            "UZS"
        case .ves:
            "VES"
        case .vnd:
            "VND"
        case .vuv:
            "VUV"
        case .wst:
            "WST"
        case .xaf:
            "XAF"
        case .xcd:
            "XCD"
        case .xof:
            "XOF"
        case .xpf:
            "XPF"
        case .yer:
            "YER"
        case .zar:
            "ZAR"
        case .zmw:
            "ZMW"
        }
    }

    var description: String {
        switch self {
        case .aed:
            "United Arab Emirates Dirham"
        case .afn:
            "Afghan Afghani"
        case .all:
            "Albanian Lek"
        case .amd:
            "Armenian Dram"
        case .ang:
            "Netherlands Antillean Guilder"
        case .aoa:
            "Angolan Kwanza"
        case .ars:
            "Argentine Peso"
        case .aud:
            "Australian Dollar"
        case .awg:
            "Aruban Florin"
        case .azn:
            "Azerbaijani Manat"
        case .bam:
            "Bosnia-Herzegovina Convertible Mark"
        case .bbd:
            "Barbadian Dollar"
        case .bdt:
            "Bangladeshi Taka"
        case .bgn:
            "Bulgarian Lev"
        case .bhd:
            "Bahraini Dinar"
        case .bif:
            "Burundian Franc"
        case .bmd:
            "Bermudian Dollar"
        case .bnd:
            "Brunei Dollar"
        case .bob:
            "Bolivian Boliviano"
        case .brl:
            "Brazilian Real"
        case .bsd:
            "Bahamian Dollar"
        case .btn:
            "Bhutanese Ngultrum"
        case .bwp:
            "Botswana Pula"
        case .byn:
            "Belarusian Ruble"
        case .bzd:
            "Belize Dollar"
        case .cad:
            "Canadian Dollar"
        case .cdf:
            "Congolese Franc"
        case .chf:
            "Swiss Franc"
        case .clp:
            "Chilean Peso"
        case .cny:
            "Chinese Yuan"
        case .cop:
            "Colombian Peso"
        case .crc:
            "Costa Rican Colón"
        case .cuc:
            "Cuban Convertible Peso"
        case .cup:
            "Cuban Peso"
        case .cve:
            "Cape Verdean Escudo"
        case .czk:
            "Czech Koruna"
        case .djf:
            "Djiboutian Franc"
        case .dkk:
            "Danish Krone"
        case .dop:
            "Dominican Peso"
        case .dzd:
            "Algerian Dinar"
        case .egp:
            "Egyptian Pound"
        case .ern:
            "Eritrean Nakfa"
        case .etb:
            "Ethiopian Birr"
        case .eur:
            "Euro"
        case .fjd:
            "Fijian Dollar"
        case .fkp:
            "Falkland Islands Pound"
        case .gbp:
            "British Pound"
        case .gel:
            "Georgian Lari"
        case .ghs:
            "Ghanaian Cedi"
        case .gip:
            "Gibraltar Pound"
        case .gmd:
            "Gambian Dalasi"
        case .gnf:
            "Guinean Franc"
        case .gtq:
            "Guatemalan Quetzal"
        case .gyd:
            "Guyanese Dollar"
        case .hkd:
            "Hong Kong Dollar"
        case .hnl:
            "Honduran Lempira"
        case .hrk:
            "Croatian Kuna"
        case .htg:
            "Haitian Gourde"
        case .huf:
            "Hungarian Forint"
        case .idr:
            "Indonesian Rupiah"
        case .ils:
            "Israeli New Shekel"
        case .inr:
            "Indian Rupee"
        case .iqd:
            "Iraqi Dinar"
        case .irr:
            "Iranian Rial"
        case .isk:
            "Icelandic Króna"
        case .jmd:
            "Jamaican Dollar"
        case .jod:
            "Jordanian Dinar"
        case .jpy:
            "Japanese Yen"
        case .kes:
            "Kenyan Shilling"
        case .kgs:
            "Kyrgyzstani Som"
        case .khr:
            "Cambodian Riel"
        case .kmf:
            "Comorian Franc"
        case .kpw:
            "North Korean Won"
        case .krw:
            "South Korean Won"
        case .kwd:
            "Kuwaiti Dinar"
        case .kyd:
            "Cayman Islands Dollar"
        case .kzt:
            "Kazakhstani Tenge"
        case .lak:
            "Lao Kip"
        case .lbp:
            "Lebanese Pound"
        case .lkr:
            "Sri Lankan Rupee"
        case .lrd:
            "Liberian Dollar"
        case .lsl:
            "Lesotho Loti"
        case .lyd:
            "Libyan Dinar"
        case .mad:
            "Moroccan Dirham"
        case .mdl:
            "Moldovan Leu"
        case .mga:
            "Malagasy Ariary"
        case .mkd:
            "Macedonian Denar"
        case .mmk:
            "Myanmar Kyat"
        case .mnt:
            "Mongolian Tögrög"
        case .mop:
            "Macanese Pataca"
        case .mru:
            "Mauritanian Ouguiya"
        case .mur:
            "Mauritian Rupee"
        case .mvr:
            "Maldivian Rufiyaa"
        case .mwk:
            "Malawian Kwacha"
        case .mxn:
            "Mexican Peso"
        case .myr:
            "Malaysian Ringgit"
        case .mzn:
            "Mozambican Metical"
        case .nad:
            "Namibian Dollar"
        case .ngn:
            "Nigerian Naira"
        case .nio:
            "Nicaraguan Córdoba"
        case .nok:
            "Norwegian Krone"
        case .npr:
            "Nepalese Rupee"
        case .nzd:
            "New Zealand Dollar"
        case .omr:
            "Omani Rial"
        case .pab:
            "Panamanian Balboa"
        case .pen:
            "Peruvian Sol"
        case .pgk:
            "Papua New Guinean Kina"
        case .php:
            "Philippine Peso"
        case .pkr:
            "Pakistani Rupee"
        case .pln:
            "Polish Zloty"
        case .pyg:
            "Paraguayan Guaraní"
        case .qar:
            "Qatari Riyal"
        case .ron:
            "Romanian Leu"
        case .rsd:
            "Serbian Dinar"
        case .rub:
            "Russian Ruble"
        case .rwf:
            "Rwandan Franc"
        case .sar:
            "Saudi Riyal"
        case .sbd:
            "Solomon Islands Dollar"
        case .scr:
            "Seychellois Rupee"
        case .sdg:
            "Sudanese Pound"
        case .sek:
            "Swedish Krona"
        case .sgd:
            "Singapore Dollar"
        case .shp:
            "Saint Helena Pound"
        case .sll:
            "Sierra Leonean Leone"
        case .sos:
            "Somali Shilling"
        case .srd:
            "Surinamese Dollar"
        case .ssp:
            "South Sudanese Pound"
        case .stn:
            "São Tomé and Príncipe Dobra"
        case .syp:
            "Syrian Pound"
        case .szl:
            "Swazi Lilangeni"
        case .thb:
            "Thai Baht"
        case .tjs:
            "Tajikistani Somoni"
        case .tmt:
            "Turkmenistani Manat"
        case .tnd:
            "Tunisian Dinar"
        case .top:
            "Tongan Paʻanga"
        case .try:
            "Turkish Lira"
        case .ttd:
            "Trinidad and Tobago Dollar"
        case .twd:
            "New Taiwan Dollar"
        case .tzs:
            "Tanzanian Shilling"
        case .uah:
            "Ukrainian Hryvnia"
        case .ugx:
            "Ugandan Shilling"
        case .usd:
            "United States Dollar"
        case .uyu:
            "Uruguayan Peso"
        case .uzs:
            "Uzbekistani Soʻm"
        case .ves:
            "Venezuelan Bolívar"
        case .vnd:
            "Vietnamese Dong"
        case .vuv:
            "Vanuatu Vatu"
        case .wst:
            "Samoan Tala"
        case .xaf:
            "Central African CFA Franc"
        case .xcd:
            "East Caribbean Dollar"
        case .xof:
            "West African CFA Franc"
        case .xpf:
            "CFP Franc"
        case .yer:
            "Yemeni Rial"
        case .zar:
            "South African Rand"
        case .zmw:
            "Zambian Kwacha"
        }
    }

    var symbol: String {
        switch self {
        case .aed:
            "د.إ"
        case .afn:
            "؋"
        case .all:
            "L"
        case .amd:
            "֏"
        case .ang:
            "ƒ"
        case .aoa:
            "Kz"
        case .ars:
            "$"
        case .aud:
            "$"
        case .awg:
            "ƒ"
        case .azn:
            "₼"
        case .bam:
            "KM"
        case .bbd:
            "$"
        case .bdt:
            "৳"
        case .bgn:
            "лв"
        case .bhd:
            "BD"
        case .bif:
            "FBu"
        case .bmd:
            "$"
        case .bnd:
            "$"
        case .bob:
            "Bs."
        case .brl:
            "R$"
        case .bsd:
            "$"
        case .btn:
            "Nu."
        case .bwp:
            "P"
        case .byn:
            "Br"
        case .bzd:
            "$"
        case .cad:
            "$"
        case .cdf:
            "FC"
        case .chf:
            "Fr"
        case .clp:
            "$"
        case .cny:
            "¥"
        case .cop:
            "$"
        case .crc:
            "₡"
        case .cuc:
            "$"
        case .cup:
            "$"
        case .cve:
            "$"
        case .czk:
            "Kč"
        case .djf:
            "Fdj"
        case .dkk:
            "kr"
        case .dop:
            "$"
        case .dzd:
            "دج"
        case .egp:
            "£"
        case .ern:
            "Nkf"
        case .etb:
            "Br"
        case .eur:
            "€"
        case .fjd:
            "$"
        case .fkp:
            "£"
        case .gbp:
            "£"
        case .gel:
            "₾"
        case .ghs:
            "₵"
        case .gip:
            "£"
        case .gmd:
            "D"
        case .gnf:
            "Fr"
        case .gtq:
            "Q"
        case .gyd:
            "$"
        case .hkd:
            "$"
        case .hnl:
            "L"
        case .hrk:
            "kn"
        case .htg:
            "G"
        case .huf:
            "Ft"
        case .idr:
            "Rp"
        case .ils:
            "₪"
        case .inr:
            "₹"
        case .iqd:
            "ع.د"
        case .irr:
            "﷼"
        case .isk:
            "kr"
        case .jmd:
            "$"
        case .jod:
            "JD"
        case .jpy:
            "¥"
        case .kes:
            "KSh"
        case .kgs:
            "сом"
        case .khr:
            "៛"
        case .kmf:
            "CF"
        case .kpw:
            "₩"
        case .krw:
            "₩"
        case .kwd:
            "KD"
        case .kyd:
            "$"
        case .kzt:
            "₸"
        case .lak:
            "₭"
        case .lbp:
            "ل.ل"
        case .lkr:
            "Rs"
        case .lrd:
            "$"
        case .lsl:
            "L"
        case .lyd:
            "LD"
        case .mad:
            "DH"
        case .mdl:
            "L"
        case .mga:
            "Ar"
        case .mkd:
            "ден"
        case .mmk:
            "K"
        case .mnt:
            "₮"
        case .mop:
            "MOP$"
        case .mru:
            "UM"
        case .mur:
            "₨"
        case .mvr:
            "Rf"
        case .mwk:
            "MK"
        case .mxn:
            "$"
        case .myr:
            "RM"
        case .mzn:
            "MT"
        case .nad:
            "$"
        case .ngn:
            "₦"
        case .nio:
            "C$"
        case .nok:
            "kr"
        case .npr:
            "₨"
        case .nzd:
            "$"
        case .omr:
            "﷼"
        case .pab:
            "B/."
        case .pen:
            "S/"
        case .pgk:
            "K"
        case .php:
            "₱"
        case .pkr:
            "₨"
        case .pln:
            "zł"
        case .pyg:
            "₲"
        case .qar:
            "﷼"
        case .ron:
            "lei"
        case .rsd:
            "дин"
        case .rub:
            "₽"
        case .rwf:
            "FRw"
        case .sar:
            "﷼"
        case .sbd:
            "$"
        case .scr:
            "₨"
        case .sdg:
            "ج.س."
        case .sek:
            "kr"
        case .sgd:
            "$"
        case .shp:
            "£"
        case .sll:
            "Le"
        case .sos:
            "S"
        case .srd:
            "$"
        case .ssp:
            "£"
        case .stn:
            "Db"
        case .syp:
            "£"
        case .szl:
            "E"
        case .thb:
            "฿"
        case .tjs:
            "ЅМ"
        case .tmt:
            "T"
        case .tnd:
            "د.ت"
        case .top:
            "T$"
        case .try:
            "₺"
        case .ttd:
            "$"
        case .twd:
            "$"
        case .tzs:
            "TSh"
        case .uah:
            "₴"
        case .ugx:
            "USh"
        case .usd:
            "$"
        case .uyu:
            "$U"
        case .uzs:
            "so'm"
        case .ves:
            "Bs.S"
        case .vnd:
            "₫"
        case .vuv:
            "VT"
        case .wst:
            "T"
        case .xaf:
            "FCFA"
        case .xcd:
            "$"
        case .xof:
            "CFA"
        case .xpf:
            "₣"
        case .yer:
            "﷼"
        case .zar:
            "R"
        case .zmw:
            "ZK"
        }
    }
}
