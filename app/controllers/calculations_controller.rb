class CalculationsController < ApplicationController

  def word_count
    @text = params[:user_text]
    @special_word = params[:user_word]

    # ================================================================================
    # Your code goes below.
    # The text the user input is in the string @text.
    # The special word the user input is in the string @special_word.
    # ================================================================================

    text_split_into_array = @text.split
    # transformed from string to array

    @word_count = text_split_into_array.size
    #counting elements in array

    @character_count_with_spaces = @text.size

    #remove spaces from @text
    @text_without_spaces = @text.gsub(" ", "")

    #tell me the size of the new string without spaces
    @character_count_without_spaces = @text_without_spaces.size

    #they've given me @special_word. I need to find it and then count it.
    #based on hint, looks like we want to use the array count function
    #we want to do this after having split the string into an array

    #first make downcase
    text_downcase = @text.downcase

    #then take out punctuation
    text_downcase_no_punctuation = text_downcase.gsub(/[^a-z0-9\s]/i, "")

    #remove punctuation: @text.gsub(/[^a-z0-9\s]/i, "")

    downcase_text_split_into_array = text_downcase_no_punctuation.split
    # transformed from string to array

    @occurrences = downcase_text_split_into_array.count(@special_word)

    # ================================================================================
    # Your code goes above.
    # ================================================================================

    render("word_count.html.erb")
  end

  def loan_payment
    @apr = params[:annual_percentage_rate].to_f
    @years = params[:number_of_years].to_i
    @principal = params[:principal_value].to_f

    # ================================================================================
    # Your code goes below.
    # The annual percentage rate the user input is in the decimal @apr.
    # The number of years the user input is in the integer @years.
    # The principal value the user input is in the decimal @principal.
    # ================================================================================

    #c = P * r / (1-(1+r)^-N)
    #r = monthly interest rate expressed as a decimal, not a percentage. this should just be the apr/12
    #N = # of monthly payments. This should just be @years*12
    #p = principal - I don't think we need to change this
    #3**2 is the exponent, not 3^2

    #come back to this

    r = @apr/12
    n = @years*12
    pr = @principal

    #@monthly_payment = pr * (r / (1-((1+r)**(-n))))
    @monthly_payment = ((((@apr/100)/12) * @principal) / (1 - (1 + ((@apr/100)/12)) ** ( -(@years * 12))))

    # ================================================================================
    # Your code goes above.
    # ================================================================================

    render("loan_payment.html.erb")
  end

  def time_between
    @starting = Chronic.parse(params[:starting_time])
    @ending = Chronic.parse(params[:ending_time])

    # ================================================================================
    # Your code goes below.
    # The start time is in the Time @starting.
    # The end time is in the Time @ending.
    # Note: Ruby stores Times in terms of seconds since Jan 1, 1970.
    #   So if you subtract one time from another, you will get an integer
    #   number of seconds as a result.
    # ================================================================================

    #I think we need to use something like time.parse here

    #first find the full time difference
    #then determine what unit we want it in
    #make sure it's positive no matter what

    if @starting > @ending
      @seconds = @starting - @ending
    else @seconds = @ending - @starting
    end

    #seconds worked, but I need to figure out the rest of it

    if @starting > @ending
      seconds = @starting - @ending
    else seconds = @ending - @starting
    end
    @minutes = seconds/60

    @hours = @seconds/3600

    @days = @seconds/86400

    @weeks = @seconds/604800

    @years = @seconds/(31536000)

    # ================================================================================
    # Your code goes above.
    # ================================================================================

    render("time_between.html.erb")
  end

  def descriptive_statistics
    @numbers = params[:list_of_numbers].gsub(',', '').split.map(&:to_f)

    # ================================================================================
    # Your code goes below.
    # The numbers the user input are in the array @numbers.
    # ================================================================================

    @sorted_numbers = @numbers.sort

    @count = @numbers.count

    @minimum = @numbers.min

    @maximum = @numbers.max

    @range = @numbers.max - @numbers.min

    #first sort
    sorted = @numbers.sort

    #if the array is an odd length
    if sorted.length % 2 != 0
      #the median is the slot in the array that is one more than the total number of slots, divided by 2
      @median = sorted[((sorted.length+1)/2)-1]
      #if the array is an even length
    else @median =  (sorted[(sorted.length/2)-1] + sorted[sorted.length/2])/2
      #add up the two middle numbers and divide that sum by 2 to find the median
    end

    #for even lengthed arrays, we need 1) the length divided by 2, plus 1 (because it starts at 0); 2) the length plus 2, divided by 2, then plus one (because it starts at 0)

    @sum = @numbers.sum

    @mean = @numbers.sum / @numbers.count

    #@variance = @numbers.variance
    #I think this will need to be a loop
    #for each number in the array
    #subtract it from the mean, and square that number
    #put the squared distance into a new array
    #sum the new array

    squared_difference_array = []            # Create an empty array

    @numbers.each do |num|       # For each element in numbers, (refer to it as "num")
      squared_difference = (num-@mean) * (num-@mean)            # Square the number
      squared_difference_array.push(squared_difference)  # Push it into the squared_numbers array
    end

    @variance = (squared_difference_array.sum)/@numbers.count  # Sum the squares


    @standard_deviation = @variance**(0.5)

    #square root of the variance found above

    #@mode = @numbers.mode

    #frequency_array = [
    #@numbers, [] #does numbers need to be in brackets?
    #]
    # Create an array of arrays

    #@numbers.each do |num|       # For each element in numbers, (refer to it as "num")
    #frequency = @numbers.count(num)   # Count how many times that number appears in the array
    #frequency_array.push(frequency)  # Push it into the frequency array - but how do I specify where in the array?
    #end

    #find the maximum number in the frequency row/column of the frequency array
    #produce the row/column of @numbers that corresponds to that maximum

    frequency_array = []
    @numbers.each do |num|       # For each element in numbers, (refer to it as "num")
      frequency = @numbers.count(num)   # Count how many times that number appears in the array
      frequency_array.push(frequency)  # Push it into the frequency array
    end

    #find the maximum number in the frequency array
    max = frequency_array.max

    #find what position it is in
    position = frequency_array.index(max)

    #produce the number from @numbers that corresponds to that maximum
    @mode=@numbers[position]

    # ================================================================================
    # Your code goes above.
    # ================================================================================

    render("descriptive_statistics.html.erb")
  end
end
