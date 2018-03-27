require 'benchmark'

class ConsecutivePrime
  def initialize(limit)
    @limit = limit
    boolean_prime_array
    find_primes
    prime_array
    find_consecutive_prime
    show_result
  end

  private

  def boolean_prime_array
    @is_prime = Array.new(@limit+1, false)
    @is_prime[2] = true
    @is_prime[3] = true
    @sqr_lim = Math.sqrt(@limit)
  end

  def find_primes
    x2 = 0
    (1..@sqr_lim).each do |i|
      x2 += 2 * i-1
      y2 = 0;
      (1..@sqr_lim).each do |j|
        y2 += 2 * j-1
        n = 4 * x2 + y2
        @is_prime[n] = !@is_prime[n] if ((n <= @limit) && (n % 12 == 1 || n % 12 == 5))
        n -= x2
        @is_prime[n] = !@is_prime[n] if ((n <= @limit) && (n % 12 == 7))
        n -= 2 * y2
        @is_prime[n] = !@is_prime[n] if ((i > j) && (n <= @limit) && (n % 12 == 11))
      end
    end
    (5..@sqr_lim).each do |i|
      if (@is_prime[i])
        n = i * i;
        j = n
        while j <= @limit
          @is_prime[j] = false
          j += n
        end
      end
    end
  end

  def prime_array
    @primes = []
    @is_prime.each_with_index {|el,i| @primes << i if el }
  end

  def find_consecutive_prime
    @hash = {}
    total_sum = @primes.inject(0, :+)
    limit = @primes.count-1
    sum =total_sum
    @hash[:terms_count] = 0
    (0..limit).each do |index|
      ind = limit
      break if (ind - index +1) < @hash[:terms_count]
      if sum < @limit && @is_prime[sum]
        result_prime  = sum
        @hash = {prime: result_prime, terms_count: ind - index +1}
        next
      end
      while ind > index
        break if (ind - index + 1) < @hash[:terms_count]
        sum -= @primes[ind]
        ind -= 1
        if sum < @limit && @is_prime[sum]
          result_prime  = sum
          @hash= {prime: result_prime, terms_count: ind - index +1}
          break
        end
      end
      sum = total_sum - @primes[0..index].inject(:+)
    end
  end

  def find_consecutive_prime_1
    @hash = {}
    (1..@limit).each do |i|
      next unless @is_prime[i]
      array = []
      result_prime = 0
      sum = 0
      @is_prime.each_with_index do |el,index|
        next if index < i
        next unless el
        sum += index
        break if index >= @limit
        result_prime = sum if @is_prime[sum]
        array.push index
      end
      sum = 0
      terms = []
      array.each do |el|
        sum += el
        break if sum > result_prime
        terms << el
      end
      next if terms.count.zero?
      @hash[i] = {prime: result_prime, terms_count: terms.count }
    end
    @result = @hash.map{|k,val|val}.max_by{|hash|hash[:terms_count]}
  end


  def show_result
    puts "The longest sum of consecutive primes below #{@limit} contains #{@hash[:terms_count]} terms and is equal to #{@hash[:prime]}"
  end
end

result = Benchmark.realtime { ConsecutivePrime.new(100000)}
puts "Calculating time of the consecutive primes - #{result}s"