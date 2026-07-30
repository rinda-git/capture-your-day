require 'rails_helper'

RSpec.describe WebPushSubscription, type: :model do
  it 'endpointがない場合は無効' do
    subscription = build(:web_push_subscription, endpoint: nil)

    expect(subscription).not_to be_valid
    expect(subscription.errors[:endpoint]).to be_present
  end

  it 'endpointが重複する場合は無効' do
    existing_subscription = create(:web_push_subscription)
    subscription = build(
      :web_push_subscription,
      endpoint: existing_subscription.endpoint
    )

    expect(subscription).not_to be_valid
    expect(subscription.errors[:endpoint]).to be_present
  end

  it 'p256dhがない場合は無効' do
    subscription = build(:web_push_subscription, p256dh: nil)

    expect(subscription).not_to be_valid
    expect(subscription.errors[:p256dh]).to be_present
  end

  it 'authがない場合は無効' do
    subscription = build(:web_push_subscription, auth: nil)

    expect(subscription).not_to be_valid
    expect(subscription.errors[:auth]).to be_present
  end
end
