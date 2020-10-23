require 'oystercard'

describe Oystercard do

#let (:station) {double :station}

oystercard = Oystercard.new


  it 'has a balance of zero' do
    expect(subject.balance).to eq(0)
  end

  describe '#top_up' do

    it 'can top up the balance' do
      expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
    end

    it 'raises an error if the maximum balance is exceeded' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up maximum_balance
      expect{ subject.top_up 1 }.to raise_error "Maximum balance of #{maximum_balance} exceeded."
    end
  end

  it 'is initially not in a journey' do
    expect(subject).not_to be_in_journey
  end

  it 'can touch in' do
    subject.top_up(10)
    subject.touch_in(:entry_station)
    expect(subject).to be_in_journey
  end

  it 'can remember my entry station' do
    subject.top_up(10)
    subject.touch_in(:entry_station)
    expect(subject.entry_station).to eq(:entry_station)
  end

  it 'will not touch in if below minimum balance' do
    expect{ subject.touch_in(:entry_station) }.to raise_error 'Insufficient balance to touch in'
  end

  it 'can touch out' do
    subject.top_up(10)
    subject.touch_in(:entry_station)
    subject.touch_out(:exit_station)
    expect(subject.in_journey).to eq false
  end

  it 'deducts fare on touch out' do
    expect{ subject.touch_out(:exit_station) }.to change{ subject.balance }.by(-Oystercard::MINIMUM_CHARGE)
  end

  it 'checks that journey log is empty' do
    expect(subject.journey_log).to eq []
  end

  it 'checks that it is logging the journey' do
    subject.top_up(10)
    subject.touch_in(:entry_station)
    subject.touch_out(:exit_station)
    expect(subject.journey_log).to eq [{start: :entry_station, end: :exit_station}]
  end

end

describe Station do

  subject{ Station.new(:name, :zone) }

  it 'exposes the station name' do
    expect(subject.name).to eq :name
  end

  it 'exposes the station zone' do
    expect(subject.zone).to eq :zone
  end

end

describe Journey do
  let (:station) { double :station }

  describe '#finish' do
    it 'returns the exit station' do
      expect(subject.finish(station)).to eq station
    end
  end

  describe '#fare' do
    it 'should return the correct fare' do
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end
  end

  describe '#complete?' do
    it 'returns false by default' do
      expect(subject.complete?).to eq false
    end

    it 'returns true if journey complete' do
      subject.finish(station)
      expect(subject.complete?).to eq true
    end
  end


  it { is_expected.to respond_to(:finish) }
  it { is_expected.to respond_to(:fare) }
  it { is_expected.to respond_to(:complete?) }

  context 'given an entry station' do

    it 'has an entry station' do
      allow(subject).to receive(:entry_station).and_return(station)
      expect(subject.entry_station).to eq station
    end
  end

end
