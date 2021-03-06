require 'benchmark'

class ConsecutivePrime
  def initialize(limit)
    @limit = limit
    boolean_prime_array
    find_primes
    primes_array
    find_consecutive_primes
    show_result
  end

  private

  def boolean_prime_array
    @is_prime = Array.new(@limit + 1, false)
    @is_prime[2] = true
    @is_prime[3] = true
  end

  def find_primes
    sqr_lim = Math.sqrt(@limit)
    x2 = 0
    (1..sqr_lim).each do |i|
      x2 += 2 * i - 1
      y2 = 0
      (1..sqr_lim).each do |j|
        y2 += 2 * j - 1
        n = 4 * x2 + y2
        @is_prime[n] = !@is_prime[n] if (n <= @limit) && (n % 12 == 1 || n % 12 == 5)
        n -= x2
        @is_prime[n] = !@is_prime[n] if (n <= @limit) && (n % 12 == 7)
        n -= 2 * y2
        @is_prime[n] = !@is_prime[n] if (i > j) && (n <= @limit) && (n % 12 == 11)
      end
    end
    (5..sqr_lim).each do |i|
      if @is_prime[i]
        n = i * i
        j = n
        while j <= @limit
          @is_prime[j] = false
          j += n
        end
      end
    end
  end

  def primes_array
    @primes = []
    @is_prime.each_with_index {|el, i| @primes << i if el }
  end

  def find_consecutive_primes
    @hash = {}
    total_sum = @primes.inject(0, :+)
    limit = @primes.count - 1
    sum = total_sum
    @hash[:terms_count] = 0
    (0..limit).each do |index|
      ind = limit
      break if (ind - index + 1) < @hash[:terms_count]
      if sum < @limit && @is_prime[sum]
        result_prime  = sum
        @hash = { prime: result_prime, terms_count: ind - index +1 }
        next
      end
      while ind > index
        break if (ind - index + 1) < @hash[:terms_count]
        sum -= @primes[ind]
        ind -= 1
        if sum < @limit && @is_prime[sum]
          result_prime  = sum
          @hash = { prime: result_prime, terms_count: ind - index +1 }
          break
        end
      end
      sum = total_sum - @primes[0..index].inject(:+)
    end
  end

  def show_result
    puts "The longest sum of consecutive primes below #{@limit} contains #{@hash[:terms_count]} terms and is equal to #{@hash[:prime]}"
  end
end

result = Benchmark.realtime { ConsecutivePrime.new(1_000_000) }
puts "Calculating time of the consecutive primes - #{result}s"
