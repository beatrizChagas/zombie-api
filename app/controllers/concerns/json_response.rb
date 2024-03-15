module JsonResponse
  extend ActiveSupport::Concern

  def render_blueprint(blueprint, object, status)
    render json: blueprint.render(object), status: status
  end

  def render_success(message, status)
    render json: { message: message } , status: status
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end