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

wyniki_dni_raw = File.read("sanepid_pomorze.txt").split("\n\n")
wyniki_dni = wyniki_dni_raw.map{ |x| x.split("\n").find_all{|lines| !lines.start_with?("#")} }

def count_results_for_days(powiaty, result_days, count)
  dni = 0
  powiaty_wyniki = {}
  
  count = result_days.size < count ? result_days.size : count
  
  result_days[-1*count, count].each do |wyniki|
    wyniki.each do |x|
      cols = x.gsub(/[,.]/, "").split(" ")
      num = cols[0] ? cols[0].to_i : 0
      
      powiat = cols.last
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
      #p [num, powiat, ludnosc, na_10_tys, kolor]
      
    end
    dni += 1
  end

  puts
  puts "Prognoza z #{dni} dni:"
  puts
  puts "```"

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
  puts "```"
end

count_results_for_days(powiaty, wyniki_dni, 5)
count_results_for_days(powiaty, wyniki_dni, 14)