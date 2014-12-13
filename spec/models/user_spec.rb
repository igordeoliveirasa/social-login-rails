require 'rails_helper'

RSpec.describe User, :type => :model do

  it "should register new user from site" do

    provider = "facebook"
    uid = "123"
    email = "my@email.com"

    user_to_be_auth = User.new(provider: provider, uid: uid, email: email)

    user = User.social_authentication(user_to_be_auth)
    expect(user).to be_nil

    unless user
      user = User.social_registration(user_to_be_auth)
    end

    expect(User.count).to eq(1)
    expect(Uid.count).to eq(1)

    expect(user.persisted?).to be true
    expect(user.provider).to eq(provider)
    expect(user.uid).to eq(uid)
    expect(user.email).to eq(email)

    expect(user.uids.count).to eq(1)
    expect(user.uids.first.persisted?).to be true
    expect(user.uids.first.provider).to eq(provider)
    expect(user.uids.first.uid).to eq(uid)
    expect(user.uids.first.user).to eq(user)
  end

  it "should login user from site using an already registered uid" do

    # registering
    provider = "facebook"
    uid = "123"
    email = "my@email.com"

    user_to_be_auth = User.new(provider: provider, uid: uid, email: email)

    user = User.social_authentication(user_to_be_auth)
    expect(user).to be_nil
    unless user
      user = User.social_registration(user_to_be_auth)
    end

    # logging
    user = User.social_authentication(user_to_be_auth)

    expect(User.count).to eq(1)
    expect(Uid.count).to eq(1)

    expect(user.persisted?).to be true
    expect(user.provider).to eq(provider)
    expect(user.uid).to eq(uid)
    expect(user.email).to eq(email)

    expect(user.uids.first.persisted?).to be true
    expect(user.uids.first.provider).to eq(provider)
    expect(user.uids.first.uid).to eq(uid)
    expect(user.uids.first.user).to eq(user)
  end

  it "should login user from site using an already registered uid even if there is a null email" do

    # registering
    provider = "facebook"
    uid = "123"
    email = "my@email.com"

    user_to_be_auth = User.new(provider: provider, uid: uid, email: email)

    user = User.social_authentication(user_to_be_auth)
    expect(user).to be_nil
    unless user
      user = User.social_registration(user_to_be_auth)
    end

    # logging
    user_to_be_auth.email = nil
    user = User.social_authentication(user_to_be_auth)

    expect(User.count).to eq(1)
    expect(Uid.count).to eq(1)

    expect(user.persisted?).to be true
    expect(user.provider).to eq(provider)
    expect(user.uid).to eq(uid)
    expect(user.email).to eq(email)

    expect(user.uids.first.persisted?).to be true
    expect(user.uids.first.provider).to eq(provider)
    expect(user.uids.first.uid).to eq(uid)
    expect(user.uids.first.user).to eq(user)
  end

  it "should register a known user with another uid but same email" do

    # registering at first
    facebook_provider = "facebook"
    facebook_uid = "123"
    facebook_email = "my@email.com"

    facebook_user_to_be_auth = User.new(provider: facebook_provider, uid: facebook_uid, email: facebook_email)

    facebook_user = User.social_authentication(facebook_user_to_be_auth)
    expect(facebook_user).to be_nil
    unless facebook_user
      facebook_user = User.social_registration(facebook_user_to_be_auth)
    end

    # registering the second using twitter
    linkedin_provider = "linkedin"
    linkedin_uid = "321"
    linkedin_email = "my@email.com"

    linkedin_user_to_be_auth = User.new(provider: linkedin_provider, uid: linkedin_uid, email: linkedin_email)

    linkedin_user = User.social_authentication(linkedin_user_to_be_auth)

    expect(linkedin_user).not_to be_nil

    expect(User.count).to eq(1)
    expect(Uid.count).to eq(2)

    expect(facebook_user.persisted?).to be true
    expect(facebook_user.provider).to eq(facebook_provider)
    expect(facebook_user.uid).to eq(facebook_uid)
    expect(facebook_user.email).to eq(facebook_email)

    expect(linkedin_user.persisted?).to be true
    expect(linkedin_user.provider).to eq(facebook_provider) # the first register
    expect(linkedin_user.uid).to eq(facebook_uid) # the first register
    expect(linkedin_user.email).to eq(linkedin_email)

    expect(linkedin_user.uids.first.persisted?).to be true
    expect(linkedin_user.uids.first.provider).to eq(facebook_provider)
    expect(linkedin_user.uids.second.provider).to eq(linkedin_provider)
    expect(linkedin_user.uids.first.uid).to eq(facebook_uid)
    expect(linkedin_user.uids.second.uid).to eq(linkedin_uid)
    expect(linkedin_user.uids.first.user).to eq(linkedin_user)
  end

  it "should register new user since the UID is different and the email is different too" do

    # registering at first
    facebook_provider = "facebook"
    facebook_uid = "123"
    facebook_email = "my@email.com"

    facebook_user_to_be_auth = User.new(provider: facebook_provider, uid: facebook_uid, email: facebook_email)

    facebook_user = User.social_authentication(facebook_user_to_be_auth)

    expect(facebook_user).to be_nil
    unless facebook_user
      facebook_user = User.social_registration(facebook_user_to_be_auth)
    end



    # registering the second using twitter
    twitter_provider = "twitter"
    twitter_uid = "321"
    twitter_email = "321@twitter.com"

    twitter_user_to_be_auth = User.new(provider: twitter_provider, uid: twitter_uid, email: twitter_email)

    twitter_user = User.social_authentication(twitter_user_to_be_auth)
    expect(twitter_user).to be_nil
    unless twitter_user
      twitter_user = User.social_registration(twitter_user_to_be_auth)
    end

    expect(User.count).to eq(2)
    expect(Uid.count).to eq(2)

    expect(facebook_user.persisted?).to be true
    expect(facebook_user.provider).to eq(facebook_provider)
    expect(facebook_user.uid).to eq(facebook_uid)
    expect(facebook_user.email).to eq(facebook_email)

    expect(twitter_user.persisted?).to be true
    expect(twitter_user.provider).to eq(twitter_provider)
    expect(twitter_user.uid).to eq(twitter_uid)
    expect(twitter_user.email).to eq(twitter_email)

    expect(twitter_user.uids.first.persisted?).to be true
    expect(twitter_user.uids.first.provider).to eq(twitter_provider)
    expect(twitter_user.uids.first.uid).to eq(twitter_uid)
    expect(twitter_user.uids.first.user).to eq(twitter_user)

    expect(facebook_user).not_to eq(twitter_user)
  end

  # registrations ===========================

end
