require 'spec_helper'

describe API::API do
  include ApiHelpers

  before do
    import_region_data_from_files
  end

  describe "GET /addresses/ids" do
    context "with invalid parameters" do
      let(:invalid_params) { { } }

      before do
        get api("/addresses/ids", invalid_params), invalid_params
      end

      context "when not providing required parameter province" do
        let(:invalid_params) { { city: "杭州", area: "上城区" } }

        it "should return 400 bad request error" do
          response.status.should == 400
        end
      end

      context "with invalid address combination" do
        let(:invalid_params) { { province: "浙江", city: "鹰潭", area: "上城区" } }

        it "returns 400 bad require error" do
          response.status.should == 400
        end
      end
    end

    context "with valid parameters" do
      before do
        get api("/addresses/ids", valid_params), valid_params
      end

      context "of normal province and cities" do
        let(:valid_params) { { province: "浙江", city: "杭州", area: "上城区" } }

        it "returns the ids of province, city and area" do
          response.status.should == 200
          response.body.should match(/"province_id":11/)
          response.body.should match(/"city_id":90/)
          response.body.should match(/"area_id":922/)
        end
      end

      context "of special provinces and cities, eg. 直辖市, 自治区" do
        context " - 上海" do
          context "市辖区" do
            let(:valid_params) { { province: "上海", city: "上海市", area: "黄浦区" } }

            it "returns the ids of province, city and area" do
              response.status.should == 200
              response.body.should match(/"province_id":9/)
              response.body.should match(/"city_id":75/)
              response.body.should match(/"area_id":783/)
            end
          end

          context "县" do
            let(:valid_params) { { province: "上海", city: "上海市", area: "崇明县" } }

            it "returns the ids of province, city and area" do
              response.status.should == 200
              response.body.should match(/"province_id":9/)
              response.body.should match(/"city_id":76/)
              response.body.should match(/"area_id":801/)
            end
          end
        end

        context " - 重庆" do
          context "市辖区" do
            let(:valid_params) { { province: "重庆", city: "重庆市", area: "万州区" } }

            it "returns the ids of province, city and area" do
              response.status.should == 200
              response.body.should match(/"province_id":22/)
              response.body.should match(/"city_id":238/)
              response.body.should match(/"area_id":2218/)
            end
          end

          context "市" do
            let(:valid_params) { { province: "重庆", city: "重庆市", area: "江津区" } }

            it "returns the ids of province, city and area" do
              response.status.should == 200
              response.body.should match(/"province_id":22/)
              response.body.should match(/"city_id":240/)
              response.body.should match(/"area_id":2254/)
            end
          end

          context "县" do
            let(:valid_params) { { province: "重庆", city: "重庆市", area: "巫山县" } }

            it "returns the ids of province, city and area" do
              response.status.should == 200
              response.body.should match(/"province_id":22/)
              response.body.should match(/"city_id":239/)
              response.body.should match(/"area_id":2248/)
            end
          end
        end

      end

    end
  end
end

