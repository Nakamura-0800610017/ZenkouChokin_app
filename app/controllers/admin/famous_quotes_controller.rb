class Admin::FamousQuotesController < Admin::BaseController
  def index
    @famous_quotes = FamousQuote.order(created_at: :desc).page(params[:page])
  end

  def new
    @famous_quote = FamousQuote.new
  end

  def create
    @famous_quote = FamousQuote.new(famous_quote_params)
    if @famous_quote.save
      redirect_to admin_famous_quotes_path, success: t("default.flash_message.created", item: FamousQuote.model_name.human)
    else
      flash.now[:danger] = t("default.flash_message.not_created", item: FamousQuote.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @famous_quote = FamousQuote.find(params[:id])
  end

  def update
    @famous_quote = FamousQuote.find(params[:id])
    if @famous_quote.update(famous_quote_params)
      redirect_to admin_famous_quotes_path, success: t("default.flash_message.updated", item: Post.model_name.human)
    else
      flash.now[:danger] = t("default.flash_message.not_updated", item: Post.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    famous_quote = FamousQuote.find(params[:id])
    famous_quote.destroy!
    redirect_to admin_famous_quotes_path, success: t("default.flash_message.deleted", item: FamousQuote.model_name.human), status: :see_other
  end

  private

  def famous_quote_params
    params.require(:famous_quote).permit(:content, :author)
  end
end
