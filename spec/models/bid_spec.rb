# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Bid, type: :model do
  it { should belong_to(:opportunity) }

  it { should validate_presence_of(:exchange) }
  it { should validate_presence_of(:value) }
end
