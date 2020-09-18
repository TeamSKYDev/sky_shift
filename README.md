# Docker君
https://qiita.com/azul915/items/5b7063cbc80192343fc0

# ridgepole導入

## Gemのインストール

```
gem 'ridgepole'
gem 'warning'
```
```
bundle install
```

## Schemafileの作成
db/にSchemafileを作る。
現在のschema情報を元に、Schemafileを生成
```
ridgepole -c config/database.yml --export -o db/Schemafile
chmod +x db/Schemafile
```

Schemafileに以下を追加
```
Dir.glob(File.expand_path("../*.schema", __FILE__)) do |file|
  require file
end
```
## あれば今後いらないので削除

- db/schema.rb
- db/migrate/*

## rake taskの追加

lib/tasks/ridgepole.rake
```
namespace :ridgepole do
  desc 'Apply database schema'
  task apply: :environment do
    ridgepole('--apply')
  end

  desc 'Export database schema'
  task export: :environment do
    ridgepole('--export')
  end

  desc 'dry-run database schema'
  task 'dry-run': :environment do
    ridgepole('--apply --dry-run')
  end

  private

  def ridgepole(*options)
    command = ['bundle exec ridgepole -f db/Schemafile', '-c config/database.yml', "-E #{Rails.env}"]
    system((command + options).join(' '))

    unless Rails.env.production?
      Rake::Task['db:schema:dump'].invoke
      Rake::Task['db:test:prepare'].invoke
      Rails.root.join('db/schema.rb').delete
    end
  end
end
```
## 使用方法
db/にhoge.schemaを作成

例 articles.schema
``` 
create_table "articles", force: :cascade do |t|
  t.string   "title"
  t.text     "text"
  
  t.datetime "created_at"
  t.datetime "updated_at"
end
```

```
rails ridgepole:dry-run 
```
で発行されるSQLを確認できる。
```
rails ridgepole:apply
```
で変更を反映できる。

## modelを作る際には
```
rails g model Foo --skip-migration
```

# bootstrap4導入

https://qiita.com/NaokiIshimura/items/c8db09daefff5c11dadf

## チートシート
https://hackerthemes.com/bootstrap-cheatsheet/#!
