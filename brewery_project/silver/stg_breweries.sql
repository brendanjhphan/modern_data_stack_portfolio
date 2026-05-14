with source as (
    select * from bronze.breweries
),

renamed as (
    select
        id                          as brewery_id,
        name                        as brewery_name,
        brewery_type,
        city,
        state_province              as state,
        country,
        longitude::numeric          as longitude,
        latitude::numeric           as latitude,
        phone,
        website_url,
        updated_at::timestamp       as updated_at,
        ingested_at
    from source
    where id is not null
)

select * from renamed
