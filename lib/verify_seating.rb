module VerifySeating
    def self.seat_arrangements(args)
        @array = JSON.parse args[:array]
        @passenger = args[:passenger].to_i
        @passengers_allocated = 0
        @max_seats = @array.inject(0) { |sum, x| sum += x[0] * x[1] }
        if @max_seats < @passenger
            return 'Warning : Passenger cannot exceed the number of max seats.'
        else
            self.prepare_seats(@array, @max_seats)
            self.allocate_aisle_seats
            self.allocate_window_seats
            self.allocate_center_seats
            return @available_seats
        end unless self.validate_arrays(@array) == false
        if self.validate_arrays(@array) == false
            return 'Warning : Element in array must be a 2D array.'
        end
    end

    def self.prepare_seats(array, max_seats)
        @available_seats = @array.each_with_object([]).with_index do |(arr, seats), index|
            seats << (1..arr[1]).map { |x| Array.new(arr[0]) { 'N' } }
        end
        @sorted_seats = (1..@max_seats).each_with_object([]).with_index do |(x, arr), index|
            arr << @available_seats.map { |x| x[index] }
        end
    end
    
    def self.validate_arrays(array)
        if !self.all_element_are_2d_array?(array)
            return false
        else
            return true
        end
    end

    private
    def self.allocate_aisle_seats
        @aisle_seats = @sorted_seats.each_with_object([]) do |elem_array, res_array|
          res_array << if elem_array.nil?
            nil
          else
            elem_array.each_with_object([]).with_index do |(basic_elem_array, update_arr), index|
              update_arr << if basic_elem_array.nil?
                nil
              else
                if index == 0
                  @passengers_allocated += 1
                  basic_elem_array[-1] = @passengers_allocated <= @passenger ? @passengers_allocated.to_s.rjust(@max_seats.to_s.size, "0") : 'X'*@max_seats.to_s.size
                elsif index == elem_array.size - 1
                  unless basic_elem_array.size == 1
                    @passengers_allocated += 1
                    basic_elem_array[0] = @passengers_allocated <= @passenger ? @passengers_allocated.to_s.rjust(@max_seats.to_s.size, "0") : 'X'*@max_seats.to_s.size
                  end
                else
                  @passengers_allocated += 1
                  basic_elem_array[0] = @passengers_allocated <= @passenger ? @passengers_allocated.to_s.rjust(@max_seats.to_s.size, "0") : 'X'*@max_seats.to_s.size
                  unless basic_elem_array.size == 1
                    @passengers_allocated += 1
                    basic_elem_array[-1] = @passengers_allocated <= @passenger ? @passengers_allocated.to_s.rjust(@max_seats.to_s.size, "0") : 'X'*@max_seats.to_s.size
                  end
                end
                basic_elem_array
              end
            end
          end
        end
    end

    def self.allocate_window_seats
        @window_seats = @aisle_seats.each_with_object([]) do |elem_array, res_array|
          res_array << if elem_array.nil?
            nil
          else
            elem_array.each_with_object([]).with_index do |(basic_elem_array, update_arr), index|
              update_arr << if basic_elem_array.nil?
                nil
              else
                if index == 0
                  @passengers_allocated += 1
                  basic_elem_array[0] = @passengers_allocated <= @passenger ? @passengers_allocated.to_s.rjust(@max_seats.to_s.size, "0") : 'X'*@max_seats.to_s.size
                elsif index == elem_array.size - 1
                  @passengers_allocated += 1
                  basic_elem_array[-1] = @passengers_allocated <= @passenger ? @passengers_allocated.to_s.rjust(@max_seats.to_s.size, "0") : 'X'*@max_seats.to_s.size
                end
                basic_elem_array
              end
            end
          end
        end
      end
    
      def self.allocate_center_seats
        @center_seats = @window_seats.each_with_object([]) do |elem_array, res_array|
          res_array << if elem_array.nil?
            nil
          else
            elem_array.each_with_object([]).with_index do |(basic_elem_array, update_arr), index|
              update_arr << if basic_elem_array.nil?
                nil
              else
                if basic_elem_array.size > 2
                  (1..basic_elem_array.size - 2).each do |x|
                    @passengers_allocated += 1
                    basic_elem_array[x] = @passengers_allocated <= @passenger ? @passengers_allocated.to_s.rjust(@max_seats.to_s.size, "0") : 'X'*@max_seats.to_s.size
                  end
                end
                basic_elem_array
              end
            end
          end
        end
      end
    
    def self.all_element_are_2d_array?(element)
        !!(element.transpose rescue nil)
    end
end