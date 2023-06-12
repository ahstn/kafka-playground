create database perfumer with owner "postgres";

create schema if not exists public;
alter schema public owner to "postgres";
grant create, usage on schema public to public;

create table if not exists brand (
    id   serial
        constraint brand_pk
            primary key,
    name text not null
);
create unique index if not exists brand_id_uindex
    on brand (id);

create table if not exists collection (
    id          serial
        constraint collection_pk
            primary key,
    brand_id    integer not null
        constraint collection_brand_id_fk
            references brand,
    description text
);
create unique index if not exists collection_id_uindex
    on collection (id);

-- This should maybe be a table
create type concentration as ENUM ('edc', 'edt', 'edp', 'perfume');
create table if not exists fragrance (
    id            serial
        constraint fragrance_pk
            primary key,
    brand_id      integer       not null
        constraint fragrance_brand_id_fk
            references brand,
    collection_id integer
        constraint fragrance_collection_id_fk
            references collection,
    concentration concentration not null,
    title         text          not null
);

create unique index if not exists fragrance_id_uindex
    on fragrance (id);

create table if not exists accord (
    id    serial
        constraint accord_pk
            primary key,
    title text
);
create unique index if not exists accord_id_uindex
    on accord (id);

create table if not exists fragrance_accords (
    fragrance_id integer not null
        constraint fragrance_fk
            references fragrance,
    accord_id      integer not null
        constraint accord_fk
            references accord
);

create table if not exists "user" (
    id       serial
        constraint user_pk
            primary key,
    forename varchar(30) not null,
    surname  varchar(30) not null
);
create unique index if not exists user_id_uindex
    on "user" (id);

create table if not exists review (
    id         serial
        constraint review_pk
            primary key,
    user_id    integer             not null
        constraint review_user_id_fk
            references "user",
    fragrance_id integer           not null
        constraint review_fragrance_id_fk
            references fragrance,
    longevity  integer default 0 not null,
    projection integer default 0 not null,
    scent      integer default 0 not null,
    "value"    integer default 0 not null,
    text      text(500),
    constraint valid_scores
        check ((longevity <= 5) and (projection <= 5) and (sillage <= 5) and (scent <= 5))
);
create unique index if not exists review_id_uindex
    on review (id);

create type season as ENUM ('spring', 'summer', 'autumn', 'winter');

insert into public.user (forename, surname)
values  ('Nancey', 'Constance'),
        ('Rudd', 'Janaway'),
        ('Alexandrina', 'Longland'),
        ('Job', 'Gillyett'),
        ('Arlin', 'Ungerechts'),
        ('Shanan', 'Andreuzzi'),
        ('Giulio', 'Avo'),
        ('Jeane', 'Abden'),
        ('Tomaso', 'Thoday'),
        ('Rad', 'Rowat');

insert into public.brand (name)
values  ('Hermès'),
        ('Tom Ford'),
        ('Yves Saint Laurent'),
        ('Dior'),
        ('Guerlain'),
        ('Kilian'),
        ('Van Cleef & Arpels'),
        ('Givenchy'),
        ('Paco Rabanne'),
        ('Chanel'),
        ('Thierry Mugler'),
        ('Creed'),
        ('Versace'),
        ('Dolce & Gabbana'),
        ('Burberry'),
        ('Armani'),
        ('Marc Jacobs'),
        ('Bvlgari'),
        ('Montblanc'),
        ('Jo Malone'),
        ('Estée Lauder');

insert into public.collection (brand_id, description)
values  (1, 'd''Terre Hermès'),
        (4, 'Dior Homme'),
        (4, 'Poison'),
        (6, 'The Liquors'),
        (7, 'Extraordinaire'),
        (2, 'Private Blend');

insert into accord (title)
values  ('Citrus'),
        ('Earthy'),
        ('Woody'),
        ('Leathery'),
        ('Fruity'),
        ('Floral'),
        ('Spicy'),
        ('Vanilla'),
        ('Sweet'),
        ('Almond'),
        ('Nutty'),
        ('Fresh'),
        ('Ozonic'),
        ('Aquatic'),
        ('Aromatic'),
        ('Green'),
        ('Patchouli'),
        ('Rose'),
        ('Oud'),
        ('Tobacco'),
        ('Powdery');

insert into fragrance_accords (fragrance_id, accord_id)
values  (1, 1), -- Terre d'Hermès
        (1, 3), 
        (1, 7), 
        (1, 15), 
        (1, 2), 
        (2, 1), -- Terre d'Hermès Eau Intense Vetiver
        (2, 3), 
        (2, 7), 
        (2, 15), 
        (2, 2), 
        (16, 8), -- Hypnotic Poison
        (16, 9), 
        (16, 10), 
        (16, 11), 
        (16, 21), 
        (16, 3), 
        (3, 1), -- Dior Homme
        (3, 4), 
        (4, 3), 
        (4, 7), 
        (5, 5), -- Apple Brandy
        (5, 3), 
        (5, 7), 
        (5, 12), 
        (6, 3), -- Angels' Share
        (6, 7), 
        (6, 9), 
        (6, 8), 
        (7, 13), -- Roses on Ice
        (7, 14), 
        (7, 15), 
        (7, 16), 
        (7, 1), 
        (8, 3), -- Moonlight Patchouli
        (8, 17), 
        (8, 4), 
        (8, 18), 
        (8, 7), 
        (8, 2), 
        (9, 3), -- Orchidee Vanille
        (9, 8), 
        (10, 3), -- Bois d'Iris
        (10, 2), 
        (11, 1), -- Neroli Portofino
        (11, 6), 
        (11, 12), 
        (11, 15), 
        (12, 4), -- Tuscan Leather
        (12, 5), 
        (12, 9), 
        (12, 3), 
        (13, 3), -- Oud Wood
        (13, 19), 
        (13, 7), 
        (13, 15), 
        (13, 8), 
        (14, 8), -- Tobacco Vanille
        (14, 9), 
        (14, 20), 
        (14, 7), 
        (15, 6), -- Poison Girl
        (15, 9); 

insert into public.fragrance (brand_id, collection_id, concentration, title)
values  (1, 1, 'edt', 'Terre d''Hermès'),
        (1, 1, 'edp', 'Terre d''Hermès Eau Intense Vetiver'),
        (2, 2, 'edt', 'Homme'),
        (2, 2, 'edp', 'Homme Intense'),
        (6, 4, 'edp', 'Apple Brandy'),
        (6, 4, 'edp', 'Angels'' Share'),
        (6, 4, 'edp', 'Roses on Ice'),
        (7, 5, 'edp', 'Moonlight Patchouli'),
        (7, 5, 'edp', 'Orchidee Vanille'),
        (7, 5, 'edp', 'Bois d''Iris'),
        (2, 6, 'edt', 'Neroli Portofino'),
        (2, 6, 'edp', 'Tuscan Leather'),
        (2, 6, 'edp', 'Oud Wood'),
        (2, 6, 'edp', 'Tobacco Vanille'),
        (2, 3, 'edp', 'Poison Girl'),
        (2, 3, 'edt', 'Hypnotic Poison'),
        (2, 3, 'edp', 'Pure Poison'),
        (9, null, 'edt', 'Phantom');

-- NB: not authentic reviews, ai generated
insert into public.review (user_id, fragrance_id, longevity, projection, value, scent, text)
    -- Terre d'Hermes Reviews
values  (1, 1, 4, 3, 3, 4, "A delightful fusion of citrus & earthy notes. Terre d'Hermès tells a tale of sophistication & depth. Truly, a classic!"), 
        (3, 1, 4, 3, 4, 5, "Terre d'Hermès is a journey through nature's core. The blend of grapefruit & vetiver is both refreshing & grounding."),
        (7, 1, 4, 3, 3, 4, "Iconic & complex, Terre d'Hermès is a versatile fragrance. However, its bold character may not appeal to all."),
    -- Dior Homme Intense Reviews
        (2, 4, 4, 3, 3, 3, "Dior Homme Intense is intoxicatingly rich. The iris & ambrette combo radiates a captivating, sensual aura."), 
        (4, 4, 4, 3, 3, 3, "Elegant & daring, this scent is not for the faint-hearted. Its powdery-woody heart is a masterpiece of perfumery."),
        (5, 4, 3, 2, 2, 4, "This version takes the classic Dior Homme to new heights. However, its intensity may be overwhelming for some."),
    -- Apple Brandy Reviews
        (1, 5, 4, 3, 3, 4, "Apple Brandy is uniquely intoxicating. Its boozy apple core enveloped in warm oak is unconventional yet appealing."),
        (2, 5, 4, 3, 3, 4, "A treat for gourmand lovers, this fragrance conjures images of cozy evenings with a glass of apple brandy."),
        (4, 5, 4, 3, 3, 4, "Rich, boozy, & subtly woody, Apple Brandy is a standout. However, its unique profile may not cater to all tastes."),
        (6, 5, 4, 3, 5, 4, "A rich, caramelised apple aroma that blends wonderfully with a dark, woody base. Like a cozy autumn evening."),
    -- Angels' Share Reviews
        (1, 6, 4, 2, 1, 4, "Angels Share is pure decadence. Cognac, cinnamon, & tonka bean create a scent that's irresistibly sumptuous."), 
        (2, 6, 4, 3, 2, 3, "For those who enjoy sweet, boozy fragrances, Angels Share is a treasure. Truly an olfactory feast!"),
        (4, 6, 3, 2, 2, 4, "Its gourmand profile is delightful, yet may prove too sweet for some. Definitely a bold choice."),
    -- Moonlight Patchouli Reviews
        (1, 8, 4, 3, 3, 4, "Moonlight Patchouli is an ode to elegance. The balance of cacao, leather, & rose creates a comforting scent."), 
        (2, 8, 5, 4, 3, 5, "A lush & velvety perfume. Its softness and understated elegance make it perfect for any occasion."),
        (7, 8, 5, 3, 3, 5, "Moonlight Patchouli exudes a soft, cozy elegance. The balance of rose and cacao is divine, but some may wish for more potency."),
        (4, 8, 4, 5, 2, 4, "Despite its name, Moonlight Patchouli is subtle & refined. However, some may find it lacking in bold character."),
    -- Neroli Portofino Reviews
        (1, 11, 2, 3, 1, 4, "Neroli Portofino transports you to an Italian summer. Its blend of neroli, citrus, & amber is truly exhilarating."), 
        (2, 11, 4, 3, 2, 5, "A bright & sunny scent, perfect for warm weather. However, its performance may disappoint for the price point."),
        (5, 11, 5, 3, 2, 5, "This fragrance is like a Mediterranean getaway in a bottle! Refreshing, but lacks the lasting power."),
        (6, 11, 2, 3, 2, 4, "Bright, invigorating and luxurious, Neroli Portofino embodies the spirit of summer. Be mindful of its modest longevity though."),
    -- Tuscan Leather
        (3, 12, 5, 4, 4, 5, "Tuscan Leather is a potent mix of leather & raspberry. Lasts all day. It's bold, but worth every penny."),
        (5, 12, 4, 3, 4, 4, "An intoxicating, warm leather scent with surprising fruity notes. Excellent longevity but can be a bit too strong."),
        (6, 12, 5, 4, 3, 5, "Tuscan Leather is a masterpiece. A potent, luxurious scent with superb longevity. High price but outstanding quality."),
    -- Oud Wood
        (1, 13, 4, 4, 4, 4, "Oud Wood is a subtle blend of woods & spices. It projects well without being overwhelming. Great scent & worth the value."),
        (6, 13, 4, 3, 4, 5, "Rich, warm, and woody. Oud Wood's performance is impressive. Pricey, but the quality matches the cost."),
        (7, 13, 4, 4, 3, 5, "Oud Wood is a classy, versatile oud scent. It lasts long & projects well. A bit pricey, but it's a standout."),
    -- Tobacco Vanille
        (2, 14, 5, 4, 4, 5, "Tobacco Vanille is a rich, comforting scent with great longevity. It's pricey but the unique scent is worth it."),
        (3, 14, 5, 5, 4, 4, "A lavish mix of tobacco and vanilla that lasts all day. Bold projection. It's an investment, but a worthy one."),
        (4, 14, 5, 5, 3, 5, "Exceptional longevity, projection, and scent. Tobacco Vanille is a luxurious indulgence. High cost, but unmatched quality."),
        (8, 14, 5, 4, 3, 5, "A warm and comforting fragrance. The blend of tobacco and vanilla creates a pleasantly sweet and spicy scent."),
        (9, 14, 4, 4, 4, 5, "Tobacco Vanille is beautifully intoxicating. Perfect for cold weather, it exudes warmth and sophistication."),
    -- Poison Girl
        (1, 15, 4, 3, 3, 4, "Poison Girl is a sweet, youthful scent. Longevity is decent but could be better. Overall, a solid value."),
        (2, 15, 5, 4, 4, 4, "Poison Girl - a charming blend of bitter orange & rose. Lasts all day, projects well. Good value."),
        (3, 15, 4, 3, 3, 3, "Sweet & appealing, Poison Girl is a great everyday scent. However, it might be too sweet for some."),
    -- Hypnotic Poison  
        (1, 16, 4, 4, 4, 5, "Hypnotic Poison is a sensual mix of vanilla & almond. Excellent projection and value for money."),
        (3, 16, 5, 4, 5, 4, "Cozy and inviting, Hypnotic Poison offers excellent longevity. It's a standout in its price range."),
        (6, 16, 5, 4, 4, 5, "Hypnotic Poison is a standout - warm, comforting and long-lasting. However, it may be too strong for some."),
        (7, 16, 5, 4, 4, 5, "It's a love potion in a bottle. The blend of vanilla and almond is both comforting and addictive."),
        (9, 16, 5, 4, 5, 4, "Hypnotic Poison envelops you in a warm, sweet cloud of vanilla and almond. Truly hypnotic and deeply sensual."),
    -- Pure Poison 
        (1, 17, 5, 4, 3, 4, "Pure Poison is a fresh, floral scent. Impressive longevity & projection, but a bit pricey."),
        (4, 17, 4, 4, 3, 5, "Pure Poison is a beautiful blend of jasmine & orange. Lasts all day, but the price point is a bit high."),
        (7, 17, 4, 3, 4, 5, "Pure Poison - a radiant floral gem. Solid performance and value, despite the higher price tag.");