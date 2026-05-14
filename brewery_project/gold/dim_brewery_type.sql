with source as (
    select distinct
        brewery_type
    from {{ ref('stg_breweries') }}
    where brewery_type is not null
),

final as (
    select
        row_number() over (order by brewery_type)   as brewery_type_key,
        brewery_type                                as brewery_type_name
    from source
)

select * from final
