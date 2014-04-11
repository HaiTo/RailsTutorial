require 'spec_helper'

describe User do
  # beforeで@userを生成して、
  before(:each) do
    @user = User.new(name: "Example User",email: "user@example.com")
  end
  # subject で以下の処理は全て@userに対してのテストとなる
  subject { @user }
  ## そもそも @userが各Method(Field)を持っているか？
  it{ should respond_to(:name)}
  it{ should respond_to(:email)}
  it { should respond_to(:password_digest)}

  ### valid(検証)済みかどうかのチェック
  ## name に対する'検証'のテスト
  # @user.valid? -> be_valid という検証用Methodが生成されている
  it {should be_valid }
  describe "when name is not present" do
    before{ @user.name = " "}
    it { should_not be_valid }
  end

  ## email に対する'検証'テスト
  describe "when email is not present" do
    before{ @user.email = " "}
    it {should_not be_valid }
  end

  ## nameの長さに対するテスト
  describe "when name is too long" do
    before{ @user.name = "a" * 51}
    it {should_not be_valid }
  end

  ### emailの正当性に対する(簡易)テスト
  # invalid(未検証)な場合失敗するテスト
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  # valid(検証済み)な場合成功するテスト
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org first.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end   
    end
  end

  # アドレスが一意かどうかのテスト
  describe "when email address is already taken" do
    before do
      ## Userを一つ取得して
      user_with_same_email = @user.dup
      ## 大文字に変換
      user_with_same_email.email = @user.email.upcase
      ## saveしてみる
      user_with_same_email.save
    end
    ## 検証
    it {should_not be_valid }
  end

  #### Passwordに対するテスト

end








