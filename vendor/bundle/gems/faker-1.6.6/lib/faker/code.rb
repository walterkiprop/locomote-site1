module Faker
  class Code < Base
    flexible :code
    class << self

      # Generates a 10 digit NPI (National Provider Identifier
      # issued to health care providers in the United States)
      def npi
        Random.new.rand(10 ** 10).to_s.rjust(10, '0')
      end

      # By default generates 10 sign isbn code in format 123456789-X
      # You can pass 13 to generate new 13 sign code
      def isbn(base = 10)
        base == 13 ? generate_base13_isbn : generate_base10_isbn
      end

      # By default generates 13 sign ean code in format 1234567890123
      # You can pass 8 to generate ean8 code
      def ean(base = 13)
        base == 8 ? generate_base8_ean : generate_base13_ean
      end

      def rut
        value = Number.number(8)
        vd = rut_verificator_digit(value)
        value << "-#{vd}"
      end

      # By default generates a Singaporean NRIC ID for someone
      # who is born between the age of 18 and 65.
      def nric(min_age = 18, max_age = 65)
        birthyear = Date.birthday(min_age, max_age).year
        prefix = birthyear < 2000 ? 'S' : 'T'
        values = birthyear.to_s[-2..-1]
        values << regexify(/\d{5}/)
        check_alpha = generate_nric_check_alphabet(values, prefix)
        "#{prefix}#{values}#{check_alpha}"
      end

      # Generate GSM modem, device or mobile phone 15 digit IMEI number.
      def imei
        generate_imei
      end

      # Retrieves a real Amazon ASIN code list taken from
      # https://archive.org/details/asin_listing
      def asin
        fetch('code.asin')
      end

    private

      # Reporting body identifier
      RBI = %w(01 10 30 33 35 44 45 49 50 51 52 53 54 86 91 98 99).freeze

      def generate_imei
        pos = 0
        str = Array.new(15, 0)
        sum = 0
        t = 0
        len_offset = 0
        len = 15

        # Fill in the first two values of the string based with the specified prefix.
        # Reporting Body Identifier list: http://en.wikipedia.org/wiki/Reporting_Body_Identifier
        arr = RBI.sample
        str[0] = arr[0].to_i
        str[1] = arr[1].to_i
        pos = 2

        # Fill all the remaining numbers except for the last one with random values.
        while pos < (len - 1)
          str[pos] = rand(0..9)
          pos += 1
        end

        # Calculate the Luhn checksum of the values thus far
        len_offset = (len + 1) % 2
        for pos in (0..(len - 1))
          if (pos + len_offset) % 2 != 0
            t = str[pos] * 2

            if t > 9
              t -= 9
            end

            sum += t
          else
            sum += str[pos]
          end
        end

        # Choose the last digit so that it causes the entire string to pass the checksum.
        str[len - 1] = (10 - (sum % 10)) % 10

        # Output the IMEI value.
        str.join('')
      end

      def generate_base10_isbn
        values = regexify(/\d{9}/)
        remainder = sum(values) { |value, index| (index + 1) * value.to_i } % 11
        values << "-#{remainder == 10 ? 'X' : remainder}"
      end

      def generate_base13_isbn
        values = regexify(/\d{12}/)
        remainder = sum(values) { |value, index| index.even? ? value.to_i : value.to_i * 3 } % 10
        values << "-#{((10 - remainder) % 10)}"
      end

      def sum(values, &block)
        values.split(//).each_with_index.inject(0) do |sum, (value, index)|
          sum + block.call(value, index)
        end
      end

      def generate_base8_ean
        values = regexify(/\d{7}/)
        check_digit = 10 - values.split(//).each_with_index.inject(0){ |s, (v, i)| s + v.to_i * EAN_CHECK_DIGIT8[i] } % 10
        values << (check_digit == 10 ? 0 : check_digit).to_s
      end

      def generate_base13_ean
        values = regexify(/\d{12}/)
        check_digit = 10 - values.split(//).each_with_index.inject(0){ |s, (v, i)| s + v.to_i * EAN_CHECK_DIGIT13[i] } % 10
        values << (check_digit == 10 ? 0 : check_digit).to_s
      end

      EAN_CHECK_DIGIT8 = [3, 1, 3, 1, 3, 1, 3]
      EAN_CHECK_DIGIT13 = [1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3]

      def rut_verificator_digit(rut)
        total = rut.to_s.rjust(8, '0').split(//).zip(%w(3 2 7 6 5 4 3 2)).collect{|a, b| a.to_i * b.to_i}.inject(:+)
        (11 - total % 11).to_s.gsub(/10/, 'k').gsub(/11/, '0')
      end

      def generate_nric_check_alphabet(values, prefix)
        weight = %w(2 7 6 5 4 3 2)
        total = values.split(//).zip(weight).collect { |a, b| a.to_i * b.to_i }.inject(:+)
        total = total + 4 if prefix == 'T'
        %w(A B C D E F G H I Z J)[10 - total % 11]
      end
    end
  end
end
