# PermalinkFu

A simple plugin for creating URL-friendly permalinks (slugs) from attributes.

Uses [`ActiveSupport::Multibyte::Handlers::UTF8Handler`](http://api.rubyonrails.org/classes/ActiveSupport/Multibyte/Handlers/UTF8Handler.html) (part of Rails since 1.2) rather than `iconv` (which is [inconsistent between platforms](http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/243426)) for normalization/decomposition.


## Usage

    class Article < ActiveRecord::Base
      has_permalink :title
    end

This will escape the title in a before_validation callback, turning e.g. "Föö!! Bàr" into "foo-bar".

The permalink is by default stored in the `permalink` attribute.

    has_permalink :title, :as => :slug
  
will store it in `slug` instead.

    has_permalink [:category, :title]
  
will store a permalink form of `"#{category}-#{title}"`.

Permalinks are guaranteed unique: "foo-bar-2", "foo-bar-3" etc are used if there are conflicts. You can set the scope of the uniqueness like

    has_permalink :title, :scope => :blog_id

This means that two articles with the same `blog_id` can not have the same permalink, but two articles with different `blog_id`s can.

Two finders are provided:

    Article.find_by_permalink(params[:id])
    Article.find_by_permalink!(params[:id])
    
These methods keep their name no matter what attribute is used to store the permalink.

The `find_by_permalink` method returns `nil` if there is no match; the `find_by_permalink!` method will raise `ActiveRecord::RecordNotFound`.

You can override the model's `to_param` method with

    has_permalink :title, :param => true
    
This means that the permalink will be used instead of the primary key (id) in generated URLs. Remember to change your controller code from e.g. `find` to `find_by_permalink!`.

You can add conditions to `has_permalink` like so:

  	class Article < ActiveRecord::Base
  	  has_permalink :title, :if => Proc.new { |article| article.needs_permalink? }
  	end

Use the `:if` or `:unless` options to specify a Proc, method, or string to be called or evaluated. The permalink will only be generated if the option evaluates to true.

You can use `PermalinkFu.escape` to escape a string manually.


## Credits

Originally extracted from [Mephisto](http://mephistoblog.com) by [technoweenie](http://github.com/technoweenie/permalink_fu/).

Conditions added by [Pat Nakajima](http://github.com/nakajima/permalink_fu/).

[Henrik Nyh](http://github.com/technoweenie/permalink_fu/) replaced `iconv` with `ActiveSupport::Multibyte`.
