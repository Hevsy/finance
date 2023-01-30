PGDMP     "                     {            finance    13.7     13.9 (Ubuntu 13.9-1.pgdg20.04+1)                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                        0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            !           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            "           1262    16402    finance    DATABASE     \   CREATE DATABASE finance WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_US.UTF-8';
    DROP DATABASE finance;
                postgres    false            #           0    0    SCHEMA public    ACL     �   REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
                   postgres    false    3            �            1259    16424    assets    TABLE     o   CREATE TABLE public.assets (
    id bigint NOT NULL,
    user_id bigint,
    symbol text,
    amount bigint
);
    DROP TABLE public.assets;
       public         heap    postgres    false            �            1259    16422    assets_id_seq    SEQUENCE     v   CREATE SEQUENCE public.assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.assets_id_seq;
       public          postgres    false    207            $           0    0    assets_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.assets_id_seq OWNED BY public.assets.id;
          public          postgres    false    206            �            1259    16415    transactions    TABLE     �   CREATE TABLE public.transactions (
    id bigint NOT NULL,
    user_id bigint,
    datetime text,
    symbol text,
    amount bigint,
    ppu double precision
);
     DROP TABLE public.transactions;
       public         heap    postgres    false            �            1259    16413    transactions_id_seq    SEQUENCE     |   CREATE SEQUENCE public.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.transactions_id_seq;
       public          postgres    false    205            %           0    0    transactions_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;
          public          postgres    false    204            �            1259    16405    users    TABLE     {   CREATE TABLE public.users (
    id bigint NOT NULL,
    username text,
    hash text,
    cash numeric DEFAULT 10000.00
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    16403    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          postgres    false    203            &           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          postgres    false    202            �           2604    16427 	   assets id    DEFAULT     f   ALTER TABLE ONLY public.assets ALTER COLUMN id SET DEFAULT nextval('public.assets_id_seq'::regclass);
 8   ALTER TABLE public.assets ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    206    207    207            �           2604    16418    transactions id    DEFAULT     r   ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);
 >   ALTER TABLE public.transactions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    205    204    205            �           2604    16408    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    202    203    203            �           2606    16444    users idx_16405_user_id 
   CONSTRAINT     U   ALTER TABLE ONLY public.users
    ADD CONSTRAINT idx_16405_user_id PRIMARY KEY (id);
 A   ALTER TABLE ONLY public.users DROP CONSTRAINT idx_16405_user_id;
       public            postgres    false    203            �           2606    16443 &   transactions idx_16415_transactions_id 
   CONSTRAINT     d   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT idx_16415_transactions_id PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.transactions DROP CONSTRAINT idx_16415_transactions_id;
       public            postgres    false    205            �           2606    16442    assets idx_16424_assets_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.assets
    ADD CONSTRAINT idx_16424_assets_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.assets DROP CONSTRAINT idx_16424_assets_pkey;
       public            postgres    false    207            �           1259    16436    idx_16405_username    INDEX     O   CREATE UNIQUE INDEX idx_16405_username ON public.users USING btree (username);
 &   DROP INDEX public.idx_16405_username;
       public            postgres    false    203            �           1259    16431    idx_16424_asset_symbol    INDEX     K   CREATE INDEX idx_16424_asset_symbol ON public.assets USING btree (symbol);
 *   DROP INDEX public.idx_16424_asset_symbol;
       public            postgres    false    207            �           1259    16432    idx_16424_user_id_index    INDEX     M   CREATE INDEX idx_16424_user_id_index ON public.assets USING btree (user_id);
 +   DROP INDEX public.idx_16424_user_id_index;
       public            postgres    false    207           