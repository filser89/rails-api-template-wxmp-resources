module Api
  module V1
    class UsersController < Api::BaseController
      skip_before_action :authenticate_user_from_token!, only: [:wx_login]

      def index
        # only for Admin user to check the users
        return render_success([]) unless current_user.admin
        @users = User.offset(offset_param).limit(per_param)
        render_success(@users.map{|x| x.show_hash})
      end

      def show
        @user = User.find_by(id: params[:id])
        render_success(@user.show_hash)
      end

      def wx_login
        # every new user will login here and create a new user and issue an auth token
        js_code = params[:code]
        return render_error(I18n.t('errors.wechat.js_code_missing'), nil) unless js_code

        client = WechatOpenidService.new(js_code)

        return render_error(I18n.t('errors.wechat.wx_app_error')) unless client.error.nil?

        result = client.request

        return render_error(I18n.t('errors.wechat.tencent_error', nil)) if result['errcode']

        user = User.find_by(wx_open_id: result['openid'])
        if user
          user.update(wx_session_key: result['session_key'])
        else
          user = User.create(wx_open_id: result['openid'], wx_session_key: result['session_key'])
        end

        auth_token = issue_jwt_token(user)
        render_success({ user: user.show_hash, auth_token: auth_token })
      end

      private

      def permitted_params
        params.require(:user).permit(:name, :email, :city, :phone, :wechat, :gender)
      end
    end
  end
end
