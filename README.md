# Skalka

![](https://i.imgur.com/rsw7QPg.png)

### Skalka — the rolling pin for your json api responses.

## Installation

Add to Gemfile

```ruby
gem "skalka"
```
Run bundle

```bash
bundle install
```

## Usage

```ruby
require "skalka"

json = %{
  {
    "data": [{
      "type": "articles",
      "id": "1",
      "attributes": {
        "title": "Wise Thought",
        "body": "You can't blame gravity for falling in love.",
        "created_at": "2015-05-22T14:56:29.000Z",
        "updated_at": "2015-05-22T14:56:28.000Z"
      },
      "relationships": {
        "author": {
          "data": { "id": "42", "type": "people" }
        },
        "comments": {
          "data": { "id": "55", "type": "comments" }
        }
      }
    }],
    "included": [
      {
        "type": "people",
        "id": "42",
        "attributes": {
          "name": "Albert Einstein",
          "age": 76,
          "gender": "male"
        }
      },
      {
        "type": "comments",
        "id": "55",
        "attributes": {
          "content": "Meh"
        }
      }
    ],
    "meta": {
      "page": "1",
      "count": "1"
    }
  }
}

Skalka.call(json)

{
  data: {
    id: "1",
    type: "articles",
    attributes: {
      title: "Wise Thought",
      body: "You can't blame gravity for falling in love.",
      created_at: "2015-05-22T14:56:29.000Z",
      updated_at: "2015-05-22T14:56:28.000Z",
      author: {
        id: "42",
        type: "authors",
        attributes: {
          id: "42", name: "Albert Einstein", age: 76, gender: "male"
        }
      },
      comments: [
        {
          id: "55",
          type: "comments",
          attributes: { id: "55", content: "Meh" }
        }
      ]
    }
  },
  meta: { page: "1", count: "1" }
}
```

## Ruby support

- 2.5.0


## Credits

Skalka is built with [transproc](https://github.com/solnic/transproc) under the hood and shares its FP spirit.
