powiaty = {
  "bytowski": {:residents => 80, :days => []},
  "chojnicki": {:residents => 97, :days => []},
  "człuchowski": {:residents => 56, :days => []},
  "gdański": {:residents => 118, :days => []},
  "kartuski": {:residents => 139, :days => []},
  "wejherowski": {:residents => 217, :days => []},
  "starogardzki": {:residents => 128, :days => []},
  "sztumski": {:residents => 42, :days => []},
  "tczewski": {:residents => 115, :days => []},
  "Gdańsk": {:residents => 471, :days => []},
  "Gdynia": {:residents => 246, :days => []},
  "Sopot": {:residents => 35, :days => []},
  "kościerski": {:residents => 72, :days => []},
  "lęborski": {:residents => 66, :days => []},
  "malborski": {:residents => 64, :days => []},
  "nowodworski": {:residents => 36, :days => []},
  "pucki": {:residents => 84, :days => []},
  "Słupsk": {:residents => 91, :days => []},
  "kwidzyński": {:residents => 84, :days => []},
  "słupski": {:residents => 98, :days => []},
}

result_days_raw = File.read("sanepid_pomorze.txt").split("\n\n")
result_days = result_days_raw.map{ |x| x.split("\n").find_all{|lines| !lines.start_with?("#")} }

def parse_line(line)
  cols = line.gsub(/[,.]/, "").split(/\s+/)
  
  if cols[0] =~ /^\d+/
    # Old format
    num = cols[0] ? cols[0].to_i : 0
    powiat = cols.last.strip
  else
    # New format
    powiat = cols[1]
    num = cols[2].to_i
  end
  
  return powiat, num
end


def parse_results(powiaty, result_days)
  days = 0
  result_days.each do |results|
    results.each do |line|
      powiat, num = parse_line(line)
      
      powiaty[powiat.to_sym][:days] << num
    end
    days += 1
    
    powiaty.each do |k, v|
      if powiaty[k][:days].size < days
        powiaty[k][:days] << 0
      end
    end
  end
  powiaty
end

def generate_prognosis(powiaty, count)
  powiaty.each do |k, v|
    days_data = powiaty[k][:days][-1*count, count]
    sum = days_data.sum
    
    na_10_tys = (sum.to_f/count*14/(powiaty[k][:residents].to_f/10)).round(2)
    kolor = "czerwony"
    powiaty[k]["prognosis_#{count}".to_sym] = [na_10_tys, kolor]
  end
  powiaty
end

def generate_moving_sums(powiaty, count)
  powiaty.each do |k, v|
    days_data = powiaty[k][:days]
    moving_sums = days_data.each_cons(count).to_a.map do |arr|
      (arr.sum.to_f/count*14/(powiaty[k][:residents].to_f/10)).round(2)
    end

    powiaty[k]["moving_sums_#{count}".to_sym] = moving_sums
  end
  powiaty
end

powiaty = parse_results(powiaty, result_days)
powiaty = generate_prognosis(powiaty, 14)
powiaty = generate_moving_sums(powiaty, 1)
powiaty = generate_moving_sums(powiaty, 7)

puts "# covid19"
puts
puts "```"
powiaty.each do |k, v|
  puts "#{k}, #{v[:residents]*1000} mieszkańców"
  puts "Zachorowania z 14 dni: #{v[:days][-14,14]}"
  puts "Suma z ostatnich 14 dni: #{v[:prognosis_14]}"
  puts "Ruchome sumy z 7 dni: #{v[:moving_sums_7][-8,8]}"
  puts "Ruchome sumy z 1 dnia: #{v[:moving_sums_1][-8,8]}"
  puts
end
puts "```"
puts "Wszystkie sumy są sumą zachorowań na N dni, po przeliczeniu proporcjonalnie na 14 dni, na 10 tysięcy mieszkańców."
puts "Kolory: powyżej 12 czerwony, poniżej żółty."
puts
puts "(generated from sanepid_pomorze.rb)"
