# NicoSearch

Ruby interface for Niconico search API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nico_search'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nico_search

## Usage

### `NicoSearch::Client#search(service, params)`
- `service` (String)
  - Select one from the following:
    - `video`, `live`, `illust`, `manga`, `book`, `channel`, `channelarticle`, `news`
- `params` (Hash)
  - [**required**] `q` (String)
    - Search keyword (you can use multiple keyword like Google search)
  - [**required**] `targets` (Array)
    - Target field to search.
  - [**required**] `fields` (Array)
    - Field to be acquired.
  - [**required**] `_sort` (String)
    - Field to be used for sorting.
  - `filters` (Hash)
  - `_offset` (Integer)
    - Maximum: 1600
    - Default: 0
  - `_limit` (Integer)
    - Default: 10
  - `_context` (String)
    - Application name.

### field
- contentId
- title
- description
- tags
- tagsExact
- categoryTags
- viewCounter (Integer)
- mylistCounter (Integer)
- startTime (Time)
- thumbnailUrl
- communityIcon
- scoreTimeshiftReserved
- liveStatus

Detailed in: https://www59.atwiki.jp/nicoapi/pages/51.html (Japanese)

### filtering
#### String
Example:
```ruby
params = {
  tags: [
    'hoge', 'fuga'
  ]
}
```

#### Integer or Time
It can be narrowed down by range. Example:
```ruby
params = {
  filters: {
    # 1000000 <= viewCounter < 2000000
    viewCounter: {
      gte: 1000000,
      lt: 2000000,
    }
  }
}
```


## Example
- Get scheduled live broadcast
  - include '小澤亜李' in title or description or tags
  - order by startTime limit 2
```ruby
require 'nico_search'
params = {
  q: '小澤亜李',
  targets: %w(title description tags),
  fields: %w(contentId title description tags start_time thumbnailUrl),
  filters: {
    startTime: {
      gte: '2017-03-29T00:00:00-09:00',
    },
    liveStatus: 'reserved',
  },
  _sort: '+startTime',
  _limit: 2,
  _context: 'nigo_search gem',
}
NicoSearch::Client.search('live', params)
# => {"meta"=>{"status"=>200, "totalCount"=>2, "id"=>"c7b7f1cf-e92d-4111-8044-6b9c01a2252c"},
#  "data"=>
#   [{"startTime"=>"2017-03-30T21:00:00+09:00",
#     "description"=>
#      "自他ともに認めるマイペース声優？大橋彩香が、自由な進行に合わせてくれる優しいゲストを招き、<br />\r\nＭＣとなって“気楽に”＆“等身大で”まわしていく番組、それが…「大橋彩香の へごまわし！」\r\n<br />\r\n大橋彩香自身が興味・関心のあるものだけをクローズアップしつつ極めてマイペースな“まわし”ぶりをお楽しみいただく1時間番組です！<br /><br />\r\n<b>『大橋彩香の へごまわし！』はチャンネル会員向けの生放送番組です。冒頭15分はどなたでも無料でご覧いただけます。チャンネル会員になると最後までご覧いただくことができます。</b><br /><br />\r\n<b>■出演</b><br />\r\nメインMC：大橋彩香<br />\r\nゲスト：小澤亜李<br /><br />\r\n<b>■メッセージ募集中！</b><br />\r\n宛先→hegomawashi@bouncy.jp<br /><br />\r\n<b>■Twitter</b><br />\r\nhttps://twitter.com/hegomawashi<br />\r\n番組ハッシュタグ #へごまわし",
#     "tags"=>"一般(その他) 大橋彩香 へごまわし バラエティ 大橋彩香のへごまわし！ 声優 小澤亜李 一般",
#     "contentId"=>"lv294290727",
#     "title"=>"【ゲスト：小澤亜李】大橋彩香の へごまわし！ 第4回",
#     "thumbnailUrl"=>"http://nicolive.cdn.nimg.jp/live/simg/img/a382/1145962.999d5e.jpg"},
#    {"startTime"=>"2017-04-02T19:00:00+09:00",
#     "description"=>
#      "<b>名古屋の魅力を発信する『project758』</b> <br /> \r\n<br /> \r\n今回の放送は羽二重 きよめ役小澤亜李さんをゲストにお招きします。\r\n<br />\r\nお楽しみに!\r\n<br /> \r\n<br /> \r\nTwitterアカウント<br /> \r\nhttp://twitter.com/prj758<br /> \r\n<br /> \r\nWebサイト<br /> \r\nhttp://p758.jp<br /> \r\n<br /></b></b>",
#     "tags"=>"Project758 小澤亜李 一般(その他) 一般",
#     "contentId"=>"lv294246759",
#     "title"=>"【ゲスト:小澤亜李】project758 おめでとうSP",
#     "thumbnailUrl"=>"http://nicolive.cdn.nimg.jp/live/simg/img/a382/1145794.92f99a.jpg"}]}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/itkq/nico_search.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

