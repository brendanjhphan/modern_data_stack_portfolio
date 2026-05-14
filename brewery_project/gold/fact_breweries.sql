with breweries as (
    select * from {{ ref('stg_breweries') }}
),

brewery_types as (
    select * from {{ ref('dim_brewery_type') }}
),

locations as (
    select * from {{ ref('dim_location') }}
),

final as (
    select
        b.brewery_id,
        b.brewery_name,
        bt.brewery_type_key,
        l.location_key,
        b.latitude,
        b.longitude,
        b.phone,
        b.website_url,
        b.updated_at,
        b.ingested_at
    from breweries b
    left join brewery_types bt
        on b.brewery_type = bt.brewery_type_name
    left join locations l
        on b.city = l.city
        and b.state = l.state
        and b.country = l.country
)

select * from final
