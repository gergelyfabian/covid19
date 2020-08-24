dni = 0

powiaty = {
  "bytowski": 80,
  "chojnicki": 97,
  "człuchowski": 56,
  "gdański": 118,
  "kartuski": 139,
  "wejherowski": 217,
  "starogardzki": 128,
  "sztumski": 41,
  "tczewski": 115,
  "Gdańsk": 470,
  "Gdynia": 246,
  "Sopot": 35,
  "kościerski": 72,
  "lęborski": 66,
  "malborski": 63,
  "nowodworski": 79,
  "pucki": 84,
  "Słupsk": 328,
  "kwidzyński": 84,
  "słupski": 98,
}

powiaty_wyniki = {}

wyniki_dni = [
"""13 osób miasto Gdańsk,
9 osób powiat wejherowski,
7 osób powiat starogardzki,
6 osób miasto Gdynia,
6 osób powiat kartuski,
5 osób powiat gdański,
3 osoby powiat pucki,
1 osoba powiat kościerski,
1 osoba powiat lęborski.""",
"""19 osób miasto Gdańsk,
7 osób powiat starogardzki,
6 osób powiat wejherowski,
5 osób powiat kartuski,
4 osoby powiat gdański,
3 osoby miasto Gdynia,
3 osoby powiat lęborski,
3 osoby powiat malborski,
2 osoby powiat sztumski
2 osoby powiat kwidzyński
1 osoba miasto Słupsk,
1 osoba powiat słupski,
1 osoby powiat pucki,
1 osoba powiat bytowski
1 osoba miasto Sopot
1 osoba powiat tczewski""",
"""17 osób miasto Gdynia,
15 osób miasto Gdańsk,
12 osób powiat starogardzki,
8 osoby powiat wejherowski,
4 osoby powiat pucki,
3 osoby powiat gdański,
2 osoby powiat nowodworski
1 osoby powiat sztumski
1 osoba powiat Słupsk,
1 osoba powiat bytowski
1 osoba powiat chojnicki
1 osoba powiat człuchowski
1 osoba powiat kościerski
1 osoba miasto Sopot""",
"""24 osoby powiat starogardzki,
16 osób miasto Gdańsk,
11 osób powiat tczewski,
10 osób powiat wejherowski,
6 osób powiat pucki,
5 osób powiat gdański,
4 osoby powiat kartuski,
3 osoby powiat chojnicki,
3 osoby miasto Gdynia,
2 osoby miasto Sopot
1 osoba powiat kościerski,
1 osoba powiat lęborski,
1 osoba powiat malborski,
1 osoba powiat nowodworski
1 osoba powiat sztumski""",
"""17 osób miasto Gdańsk,
10 osób miasto Gdynia,
9 osób powiat starogardzki,
7 osób powiat wejherowski,
6 osób powiat tczewski,
3 osoby powiat gdański,
2 osoby powiat kartuski,
2 osoby miasto Sopot,
2 osoby powiat pucki,
2 osoby powiat malborski,
2 osoby powiat człuchowski
1 osoba powiat kościerski,
1 osoba powiat lęborski,
1 osoba powiat sztumski.""",
"""28 osób miasto Gdańsk,
16 osób powiat kartuski,
16 osób powiat wejherowski,
7 osób miasto Gdynia,
5 osób powiat sztumski,
4 osoby miasto Sopot,
2 osoby powiat pucki,
2 osoby powiat tczewski,
1 osoba powiat gdański,
1 osoba powiat kwidzyński,
1 osoba powiat lęborski
1 osoba powiat malborski,
1 osoba powiat nowodworski,
1 osoba miasto Słupsk.""",
]

wyniki_dni.each do |wyniki|
  wyniki.split("\n").each do |x|
    cols = x.gsub(/[,.]/, "").split(" ")
    num = cols[0] ? cols[0].to_i : 0
    
    powiat = cols[3]
    ludnosc = powiaty[powiat.to_sym]
    
    unless powiaty_wyniki[powiat.to_sym]
      powiaty_wyniki[powiat.to_sym] = 0
    end
    powiaty_wyniki[powiat.to_sym] += num
    
    na_10_tys = num*14/(ludnosc.to_f/10)
    kolor = if na_10_tys >= 12
      "czerwony"
    elsif na_10_tys >= 6
      "zółty"
    elsif na_10_tys >= 4
      "prawie żółty"
    else
      "zielony"
    end
    p [num, powiat, ludnosc, na_10_tys, kolor]
    
  end
  dni += 1
  puts
end

puts "Prognoza z #{dni} dni:"

powiaty_wyniki.each do |powiat,num|
  ludnosc = powiaty[powiat.to_sym]
  
  na_10_tys = num.to_f/dni*14/(ludnosc.to_f/10)
  kolor = if na_10_tys >= 12
    "czerwony"
  elsif na_10_tys >= 6
    "zółty"
  elsif na_10_tys >= 4
    "prawie żółty"
  else
    "zielony"
  end
  p [num, powiat, ludnosc, na_10_tys, kolor]
end
