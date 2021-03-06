require 'spec_helper'

describe "Static Pages" do

  subject{page} #全てpageに対する操作。よって先に宣言出来る
  shared_examples_for "all static pages" do
    # 共有するexamples、つまりテストの実行部
    it {should have_content(heading)} #ここでheadingは任意のObject
    it {should have_title(full_title(page_title))}
  end

  describe "Home page" do
    before{ visit root_path} #事前フィルター
    let(:heading) { 'Sample App' } # :headingにブロック内の評価された値が格納される
    let(:page_title) { '' }
    it_should_behave_like "all static pages" 
    it {should_not have_title('| Home')}

    # サインイン済みユーザーのページに対するテスト
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost,user: user,content:"Lorem ipsum")
        FactoryGirl.create(:micropost,user: user,content:"Dolor sit amet")
        sign_in user
        visit root_path
      end
      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
      # フォロー、フォロワーのカウント
      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end
        # 
        it { should have_link("0 following",href: following_user_path(user)) }
        it { should have_link("1 followers",href: followers_user_path(user)) }
      end

      # 統計情報のテスト：マイクロソフトの所有数のテスト/ RootPATH
      describe "Micropost counts" do
        #let(:micropost) { 30.times{FactoryGirl.create(:micropost,user: user)} }
        #before {visit users_path(user)}
        it { should have_content("#{user.microposts.size} microposts") }
      end
    end
  end

  describe "Help page" do
    before{ visit help_path}
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }
  end

  describe "About page" do
    before{ visit about_path}
    let(:heading) { 'About Us' }
    let(:page_title) { 'About Us' }
  end

  describe "Contact Page" do
    before{ visit contact_path}
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }
  end

  ### レイアウトのリンクに対するテスト群
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    #expect(page).to have_title(full_title('About Us'))
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end
end