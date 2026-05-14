with source as (
    select distinct
        city,
        state,
        country
    from {{ ref('stg_breweries') }}
    where city is not null
),

final as (
    select
        row_number() over (order by country, state, city)   as location_key,
        city,
        state,
        country
    from source
)

select * from final
