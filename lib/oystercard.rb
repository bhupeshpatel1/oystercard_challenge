class Oystercard

  attr_reader :balance, :entry_station, :in_journey, :exit_station, :journey_log, :station_name

  MAXIMUM_BALANCE = 90
  MINIMUM_CHARGE = 1

  def initialize
    @balance = 0
    @in_journey = false
    @entry_station = nil
    @journey_log = []
  end

  def top_up(amount)
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded." if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def in_journey?
    !!entry_station
  end

  def touch_in(station_name)
    fail 'Insufficient balance to touch in' if balance < MINIMUM_CHARGE
    @in_journey = true
    @entry_station = station_name
  end

  def touch_out(station_name)
    deduct(MINIMUM_CHARGE)
    @in_journey = false
    @entry_reader = nil
    @exit_station = station_name
    @journey_log << {start: @entry_station, end: @exit_station}
  end

  private

  def deduct(amount)
    @balance -= amount
  end

end

class Station

attr_reader :name, :zone

  def initialize(name, zone)
    @name = name
    @zone = zone
  end

end
