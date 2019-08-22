Workarea Save For Later
================================================================================

Increase average order values and help retail customers save items for later without having to create an account.

This plugin allows a consumer with or without an account to move items from their cart to a "Saved For Later" list that displays on the cart page. For users without an account, this list is persisted through a cookie that will retain their list on their browser. For users with accounts, this list is tied to their account directly and will appear in any browser they log into allow quick access to items they may be considering for purchase.

Features
--------------------------------------------------------------------------------

* Each product in cart will display a “Save for later” link
* Moving a product from the regular cart to the saved cart will remove it from the cart
* Saved cart product list item will maintain SKU, quantity, and customizations
* Each product listed in the saved cart will display a “Move to cart” link
* Moving a product from the saved cart to the regular cart will remove it from the saved cart
* If a consumer has not saved any products to a saved cart the saved cart will not display
* Cookie-based list for guests, tied to account's for signed in users.
* Lists created while logged out will merge into a consumer's existing list if they log in after adding items to their "Saved for Later" list
* Utilizes existing cart HTML/CSS to add no additional components that need to be styled.
* Lists created by guest users are pruned from the database after a
  predetermined length of time (**default:** 3 months)

Configuration
--------------------------------------------------------------------------------

`Workarea.config.saved_lists_expiration` configures the expiration time for `Workarea::SavedList` records. Using [MongoDB's TTL Indexes](https://docs.mongodb.com/manual/core/index-ttl/), we can leverage the database to prune these documents in a background thread when they are no longer relevant. This is used to define the `expireAfterSeconds` parameter on the TTL index, which means if this setting is changed, you'll have to rebuild indexes for the `SavedList` model like so:

```ruby
Workarea::SavedList.remove_indexes
Workarea::SavedList.create_indexes
```

To make sure your changes were taken up, view the specification for the TTL index like so:

```ruby
Workarea::SavedList.index_specifications

=> [#<Mongoid::Indexable::Specification:0x00007fd52a3b9078
  @fields=[:user_id],
  @key={:user_id=>1},
  @klass=Workarea::SavedList,
  @options={}>,
 #<Mongoid::Indexable::Specification:0x00007fd52a3acc10
  @fields=[:updated_at],
  @key={:updated_at=>1},
  @klass=Workarea::SavedList,
  @options=
   {:expire_after=>1 month, # <<< this is what should change
    :partial_filter_expression=>{:user_id=>{"$eq"=>nil}}}>]
```

Getting Started
--------------------------------------------------------------------------------

This gem contains a rails engine that must be mounted onto a host Rails application.

To access Workarea gems and source code, you must be an employee of WebLinc or a licensed retailer or partner.

Workarea gems are hosted privately at https://gems.weblinc.com/.
You must have individual or team credentials to install gems from this server. Add your gems server credentials to Bundler:

    bundle config gems.weblinc.com my_username:my_password

Or set the appropriate environment variable in a shell startup file:

    export BUNDLE_GEMS__WEBLINC__COM='my_username:my_password'

Then add the gem to your application's Gemfile specifying the source:

    # ...
    gem 'workarea-save_for_later', source: 'https://gems.weblinc.com'
    # ...

Or use a source block:

    # ...
    source 'https://gems.weblinc.com' do
      gem 'workarea-save_for_later'
    end
    # ...

Update your application's bundle.

    cd path/to/application
    bundle

Workarea Platform Documentation
--------------------------------------------------------------------------------

See [http://developer.weblinc.com](http://developer.weblinc.com) for Workarea platform documentation.

Copyright & Licensing
--------------------------------------------------------------------------------

Copyright WebLinc 2018. All rights reserved.

For licensing, contact sales@workarea.com.
