--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7
-- Dumped by pg_dump version 13.9 (Ubuntu 13.9-1.pgdg20.04+1)

-- Started on 2023-01-30 11:22:31 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 207 (class 1259 OID 16424)
-- Name: assets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assets (
    id bigint NOT NULL,
    user_id bigint,
    symbol text,
    amount bigint
);


ALTER TABLE public.assets OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 16422)
-- Name: assets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.assets_id_seq OWNER TO postgres;

--
-- TOC entry 3875 (class 0 OID 0)
-- Dependencies: 206
-- Name: assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assets_id_seq OWNED BY public.assets.id;


--
-- TOC entry 205 (class 1259 OID 16415)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    id bigint NOT NULL,
    user_id bigint,
    datetime text,
    symbol text,
    amount bigint,
    ppu double precision
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 16413)
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transactions_id_seq OWNER TO postgres;

--
-- TOC entry 3876 (class 0 OID 0)
-- Dependencies: 204
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- TOC entry 203 (class 1259 OID 16405)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username text,
    hash text,
    cash numeric DEFAULT 10000.00
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 16403)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 3877 (class 0 OID 0)
-- Dependencies: 202
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3729 (class 2604 OID 16427)
-- Name: assets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets ALTER COLUMN id SET DEFAULT nextval('public.assets_id_seq'::regclass);


--
-- TOC entry 3728 (class 2604 OID 16418)
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- TOC entry 3726 (class 2604 OID 16408)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3731 (class 2606 OID 16444)
-- Name: users idx_16405_user_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT idx_16405_user_id PRIMARY KEY (id);


--
-- TOC entry 3734 (class 2606 OID 16443)
-- Name: transactions idx_16415_transactions_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT idx_16415_transactions_id PRIMARY KEY (id);


--
-- TOC entry 3737 (class 2606 OID 16442)
-- Name: assets idx_16424_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assets
    ADD CONSTRAINT idx_16424_assets_pkey PRIMARY KEY (id);


--
-- TOC entry 3732 (class 1259 OID 16436)
-- Name: idx_16405_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_16405_username ON public.users USING btree (username);


--
-- TOC entry 3735 (class 1259 OID 16431)
-- Name: idx_16424_asset_symbol; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_16424_asset_symbol ON public.assets USING btree (symbol);


--
-- TOC entry 3738 (class 1259 OID 16432)
-- Name: idx_16424_user_id_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_16424_user_id_index ON public.assets USING btree (user_id);


--
-- TOC entry 3874 (class 0 OID 0)
-- Dependencies: 3
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM rdsadmin;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-01-30 11:22:36 UTC

--
-- PostgreSQL database dump complete
--

