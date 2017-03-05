# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Opportunity, type: :model do
  it { should have_one(:bid).dependent(:destroy) }
  it { should have_one(:ask).dependent(:destroy) }
end
