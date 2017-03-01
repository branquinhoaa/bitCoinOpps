require 'rails_helper'

RSpec.describe Ask, type: :model do
  it { should belong_to(:opportunity) }

  it { should validate_presence_of(:exchange) }
  it { should validate_presence_of(:value) }
end
