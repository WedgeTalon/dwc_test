--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6 (Debian 16.6-1.pgdg120+1)
-- Dumped by pg_dump version 16.6 (Debian 16.6-1.pgdg120+1)

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
-- Name: cache; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache OWNER TO root;

--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);


ALTER TABLE public.cache_locks OWNER TO root;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    account_number character varying(255) NOT NULL,
    customer_name character varying(255) NOT NULL,
    billing_address_1 character varying(255) NOT NULL,
    billing_address_2 character varying(255),
    billing_city character varying(255) NOT NULL,
    billing_state character varying(255) NOT NULL,
    billing_zip character varying(255) NOT NULL,
    shipping_address_1 character varying(255) NOT NULL,
    shipping_address_2 character varying(255),
    shipping_city character varying(255) NOT NULL,
    shipping_state character varying(255) NOT NULL,
    shipping_zip character varying(255) NOT NULL,
    phone character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    business_type character varying(255) NOT NULL,
    shipment_day json NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT customers_business_type_check CHECK (((business_type)::text = ANY ((ARRAY['Corporation'::character varying, 'LLC'::character varying, 'Sole Proprietor'::character varying, 'Other'::character varying])::text[])))
);


ALTER TABLE public.customers OWNER TO root;

--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_id_seq OWNER TO root;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.failed_jobs OWNER TO root;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.failed_jobs_id_seq OWNER TO root;

--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;


--
-- Name: job_batches; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);


ALTER TABLE public.job_batches OWNER TO root;

--
-- Name: jobs; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);


ALTER TABLE public.jobs OWNER TO root;

--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.jobs_id_seq OWNER TO root;

--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);


ALTER TABLE public.migrations OWNER TO root;

--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.migrations_id_seq OWNER TO root;

--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;


--
-- Name: password_reset_tokens; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);


ALTER TABLE public.password_reset_tokens OWNER TO root;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);


ALTER TABLE public.sessions OWNER TO root;

--
-- Name: users; Type: TABLE; Schema: public; Owner: root
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);


ALTER TABLE public.users OWNER TO root;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: root
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO root;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: root
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.cache (key, value, expiration) FROM stdin;
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.cache_locks (key, owner, expiration) FROM stdin;
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.customers (id, account_number, customer_name, billing_address_1, billing_address_2, billing_city, billing_state, billing_zip, shipping_address_1, shipping_address_2, shipping_city, shipping_state, shipping_zip, phone, email, business_type, shipment_day, created_at, updated_at) FROM stdin;
21	2482885765	Mr. Nikko Bartoletti	7525 Vanessa Mountains	\N	Kuhlmanside	MT	11188	9102 Major Union	Apt. 080	Lake Unique	PA	96079-0279	(182) 239-0331	otrantow@example.net	Other	["T","M","F","R","W"]	2023-12-16 07:45:11	2024-11-25 17:46:46
22	2642279973	Owen Hand	80818 Jordane Spur	\N	West Priscillahaven	VA	60832	86107 Streich Forges	\N	South Aureliofurt	MD	70483	(263) 633-1583	stracke.brianne@example.com	Sole Proprietor	["F","R","T","W","M"]	2024-07-09 15:01:52	2024-11-25 17:46:46
23	8331685488	Krystina O'Keefe	58138 Stamm Cliff	Apt. 162	Reicherttown	PA	79793	811 Kavon Cape Apt. 973	Apt. 582	East Jaynestad	SC	20774-4861	(772) 727-5028	austen.moore@example.net	Sole Proprietor	["T","R","M","W","F"]	2024-02-29 18:16:58	2024-11-25 17:46:46
24	6376088511	Aiyana Stehr	851 Schoen Meadows	Suite 541	Hintzfort	VA	62125	41249 Haley Fort	\N	Leoneltown	AR	93163-1095	(483) 430-0639	xlarson@example.com	Sole Proprietor	["M","F","T"]	2024-01-25 06:07:54	2024-11-25 17:46:46
25	2144040507	Tina Fritsch	2988 Melyna Squares Apt. 169	Apt. 760	North Maryamberg	RI	35598-2367	4914 Boyer Rapid Suite 019	Apt. 657	South Annalisefort	MI	85752-3008	(109) 703-1232	anderson.josie@example.com	Corporation	["M","F","W"]	2024-11-24 19:05:05	2024-11-25 17:46:46
26	5198368087	Prof. Harvey Lueilwitz PhD	3481 Reinger Orchard Apt. 763	\N	Estefaniahaven	GA	36934-9746	151 Conn Glen Suite 167	\N	Port Tre	AL	18868-9560	(060) 450-5781	kmarks@example.org	Corporation	["T"]	2024-04-28 07:13:59	2024-11-25 17:46:46
27	7795447866	Nella Abshire	1943 Rogahn Cliff	Suite 802	West Bailee	MO	93131	26263 Reilly Vista	Apt. 345	West Haliemouth	DE	33680-6852	(290) 174-8094	buckridge.ladarius@example.net	Corporation	["R","W","F","M"]	2023-12-08 17:14:56	2024-11-25 17:46:46
28	4267710876	Lucile Ferry PhD	471 Streich Mall	\N	Gagebury	RI	92862	16962 Mertz Mews	Suite 517	Sonnychester	SD	63920-3352	(148) 620-7762	vhilpert@example.com	Corporation	["F","R"]	2024-08-09 17:22:52	2024-11-25 17:46:46
29	5351614608	Dr. Larry Sawayn	288 Gianni Highway	\N	North Lulatown	MI	47821-7140	67089 Rogelio Ports	\N	East Maidabury	TX	59633	(796) 409-8297	helmer04@example.org	Sole Proprietor	["R","W","T"]	2024-11-11 19:41:50	2024-11-25 17:46:46
31	7700904695	Monica Larkin	9354 Garth Ports Suite 473	Apt. 587	Garlandport	LA	87510	491 Grant Drives	\N	Groverburgh	NJ	81631-0958	(783) 088-2087	jaskolski.kylee@example.com	Sole Proprietor	["F","T","W"]	2024-01-24 17:41:14	2024-11-25 17:46:46
32	2763326373	Prof. Bertram Funk PhD	617 Raven Haven Apt. 837	\N	West Jamar	WY	27270	5227 Carmel Pass Suite 897	Apt. 219	Fletchermouth	NM	56578	(733) 657-5904	treutel.darrion@example.net	LLC	["M"]	2024-02-10 08:49:08	2024-11-25 17:46:46
33	8151490233	Susanna Spencer DVM	1060 Stephen Haven	Apt. 709	Kingberg	AK	34712	78231 Rebecca Plains Suite 790	\N	Emorybury	KY	06905-4733	(751) 620-5302	hallie31@example.com	Corporation	["R","F","W","T"]	2023-12-09 17:18:28	2024-11-25 17:46:46
34	1438219254	Miss Vena Wiegand DVM	66716 Emile Court	Suite 555	Zulaufchester	MN	72268-2813	162 Dennis Island Apt. 422	\N	Feestberg	NV	18752	(101) 889-5969	randal69@example.net	LLC	["R","W","M","F"]	2023-12-16 11:34:37	2024-11-25 17:46:46
35	5944982769	Dr. Madisyn Cartwright	81386 Mario Plain Suite 152	\N	Crooksburgh	NE	71797	9846 Schmidt Fort	\N	Koepptown	VT	24159-9117	(666) 764-9480	hadley47@example.com	Corporation	["T","F","W"]	2023-12-30 15:33:08	2024-11-25 17:46:46
36	8073034803	Teresa Emmerich	8768 Raphael Passage	\N	North Kaylahaven	CT	85682-5186	3280 Jessika Drive Suite 239	\N	Frederikville	IL	85931	(402) 278-6412	hbogan@example.net	Sole Proprietor	["R","W","T","M"]	2024-08-30 11:36:58	2024-11-25 17:46:46
37	6880531415	Alessandro Vandervort	3261 Marvin Lakes	Suite 610	North Aubree	TN	82212	1633 Hollis Mountains Apt. 336	Apt. 701	Marquardtshire	GA	34680-5490	(471) 124-3977	jordyn32@example.com	Corporation	["F","M","R","T","W"]	2024-01-10 10:48:26	2024-11-25 17:46:46
38	4150519604	Tom Watsica	469 Gorczany Divide Suite 806	\N	West Tannermouth	CO	82081-1217	976 Antwon Extension Suite 758	Suite 307	New Chaim	OR	51841-4481	(507) 694-7000	lwalker@example.net	Other	["T","F","M","W","R"]	2024-04-25 17:03:09	2024-11-25 17:46:46
39	2606589728	Prof. Charlene Muller	7657 Wendy Ridges	Suite 750	West Lucileshire	MD	15833-1655	839 Ernser Points Apt. 530	\N	Kundeberg	AZ	49938-0100	(562) 621-1917	qabernathy@example.net	LLC	["F"]	2024-08-23 01:52:39	2024-11-25 17:46:46
40	6597942680	Alberto Ferry	972 McKenzie Ways Suite 286	Suite 161	West Zula	DE	75636	33834 Fern Haven	\N	New Mallieborough	MD	85325	(432) 231-0803	hickle.mathew@example.org	Sole Proprietor	["M"]	2024-02-23 23:43:04	2024-11-25 17:46:46
30	0761021436	Prof. Candido Marquardt III	703 Chadd Motorway	\N	East Millerside	MO	35434	450 Stroman Stravenue Apt. 878	Suite 364	New Granville	TN	13508	(822) 793-3703	catalina88@example.org	Sole Proprietor	["W"]	2024-10-02 12:55:50	2024-11-25 17:51:29
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
\.


--
-- Data for Name: job_batches; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.job_batches (id, name, total_jobs, pending_jobs, failed_jobs, failed_job_ids, options, cancelled_at, created_at, finished_at) FROM stdin;
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.jobs (id, queue, payload, attempts, reserved_at, available_at, created_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.migrations (id, migration, batch) FROM stdin;
1	0001_01_01_000000_create_users_table	1
2	0001_01_01_000001_create_cache_table	1
3	0001_01_01_000002_create_jobs_table	1
5	2024_11_24_133259_create_customers_table	2
\.


--
-- Data for Name: password_reset_tokens; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
Lg0adSm6fsjD0U9RuxRnD6u0nrfP4qnwhPUkg93O	\N	172.28.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiSTMyTHFKUHBmbUU5WHJFVTAxYnpsVjNnOEhKN2Iyc25PVUxBNHZadSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6Mjc6Imh0dHBzOi8vbG9jYWxob3N0L2N1c3RvbWVycyI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=	1732499693
gwNP0RHXThuRqgYkhG9azdsrrzfYUGdrLiypfvPZ	\N	192.168.112.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36 Edg/130.0.0.0	YTozOntzOjY6Il90b2tlbiI7czo0MDoiVHBkc2htVDBNZDhpVjR4eVVrRVU5cGd3eUxraHNmMlpJY2pNUnM0bSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MTc6Imh0dHBzOi8vbG9jYWxob3N0Ijt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==	1732556909
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: root
--

COPY public.users (id, name, email, email_verified_at, password, remember_token, created_at, updated_at) FROM stdin;
6	Test User	test@example.com	2024-11-25 17:46:45	$2y$12$R.rr55EkxOAgUJ0L1NS2DeWo3Z8heFWJHIWMqtc0di69VO9zyAO4u	SPYGtTcdi1	2024-11-25 17:46:45	2024-11-25 17:46:45
\.


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.customers_id_seq', 40, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.migrations_id_seq', 5, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: root
--

SELECT pg_catalog.setval('public.users_id_seq', 6, true);


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- Name: customers customers_account_number_unique; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_account_number_unique UNIQUE (account_number);


--
-- Name: customers customers_email_unique; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_unique UNIQUE (email);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);


--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: password_reset_tokens password_reset_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: root
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);


--
-- Name: sessions_last_activity_index; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);


--
-- Name: sessions_user_id_index; Type: INDEX; Schema: public; Owner: root
--

CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);


--
-- PostgreSQL database dump complete
--

