#!/usr/bin/env ruby

class Norme

  def initialize file
    @file = File.open(file)
    @data = @file.read
    @c_comments = {}
    @cpp_comments = {}
   end

  def parsing
    line_num = 0
    @data.gsub!(/\r\n?/, "\n")
    @data.each_line do |line|
        line_num += 1
        i = 0
        while line[i] != "\n" and line[i] != nil do
            if line[i] == '"'
                  i += stringdetected line, i += 1
              elsif line[i] == "/" and line[i + 1] == "/"
                  orig = i
                  #puts line[i...line.length]
                i += commentcpp line, i
                @cpp_comments[line_num] = line[orig...i]
                line.gsub(line[orig...i], "\n")
            elsif line[i] == "/" and line[i + 1] == "*"
                orig = i
                i += commentc line, i
                @c_comments[line_num] = line[orig...i]
                line.gsub(line[orig...i], "\n")
              else
                  i += 1
           # puts line_num
            end
        end
    end
  end

  def stringdetected line, index
    i = index
    #puts line[i...line.length]
    while line[i] !=  '"' and line[i] != nil do
      if line[i] == '\\'
          i = strjump line, i
      end
      if line[i] == '"'
          i += 1
          return i - index + 1
      end
      i += 1
    end
    #puts "string is over"
    #puts i
    return i
  end

  def strjump line, index
      j = index
      back_nbr = 0
      while line[j] == '\\' do
        if back_nbr % 2 == 1
            if line[j + 1] == '"'
                j += 1
                return j
            end
        end
        back_nbr += 1
        #puts back_nbr        
          j += 1
      end
      return j
  end

  def commentc line, index
    i = index
    while line[i...i + 2] != "*/" and line[i] != nil do
      i += 1
    end
    #puts "C is over"
    return i
  end

  def commentcpp line, index
    i = index
    while line[i] != '\n' and line[i] != nil do
      i += 1
    end
    #puts "Cpp is over"
    return i
  end

  def run
    parsing
    p @c_comments
    p @cpp_comments
  end

end

$*.each {|file| Norme.new(file).run}