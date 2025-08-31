module ApplicationHelper
  def default_meta_tags
    {
      site: "~日常を見直す習慣管理アプリ~",
      title: "善行貯金",
      reverse: true,
      separator: "|",
      description: "「良いこと」を貯めて、良いことをできなかったときの自分を許しやすくするサービス",
      keywords: "善行貯金,善行,習慣",
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_url("favicon.png"), rel: "icon", type: "image/png", sizes: "32x32" },
        { href: image_url("apple-touch-icon.png"), rel: "apple-touch-icon", sizes: "180x180" }
      ],
      og: {
        site_name: "~日常を見直す習慣管理アプリ~",
        title: "善行貯金",
        description: "「良いこと」を貯めて、良いことをできなかったときの自分を許しやすくするサービス",
        type: "website",
        url: request.original_url,
        image: image_url("ogp.png"),
        locale: "ja_JP"
      },
      twitter: {
        card: "summary_large_image",
        image: image_url("ogp.png")
      }
    }
  end
end
