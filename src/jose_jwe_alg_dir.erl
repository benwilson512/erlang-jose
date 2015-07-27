%% -*- mode: erlang; tab-width: 4; indent-tabs-mode: 1; st-rulers: [70] -*-
%% vim: ts=4 sw=4 ft=erlang noet
%%%-------------------------------------------------------------------
%%% @author Andrew Bennett <andrew@pixid.com>
%%% @copyright 2014-2015, Andrew Bennett
%%% @doc
%%%
%%% @end
%%% Created :  23 Jul 2015 by Andrew Bennett <andrew@pixid.com>
%%%-------------------------------------------------------------------
-module(jose_jwe_alg_dir).

-include("jose_jwk.hrl").

%% jose_jwe callbacks
-export([from_map/1]).
-export([to_map/2]).
%% jose_jwe_alg callbacks
-export([key_decrypt/3]).
-export([key_encrypt/3]).
-export([next_cek/4]).
%% API

%% Types
-type alg() :: dir.

-export_type([alg/0]).

%%====================================================================
%% jose_jwe callbacks
%%====================================================================

from_map(F = #{ <<"alg">> := <<"dir">> }) ->
	{dir, maps:remove(<<"alg">>, F)}.

to_map(dir, F) ->
	F#{ <<"alg">> => <<"dir">> }.

%%====================================================================
%% jose_jwe_alg callbacks
%%====================================================================

key_decrypt(Key, _EncryptedKey, dir) when is_binary(Key) ->
	Key;
key_decrypt(#jose_jwk{kty={KTYModule, KTY}}, _EncryptedKey, dir) ->
	KTYModule:derive_key(KTY).

key_encrypt(_Key, _DecryptedKey, dir) ->
	{<<>>, dir}.

next_cek(Key, _ENCModule, _ENC, dir) when is_binary(Key) ->
	Key;
next_cek(#jose_jwk{kty={KTYModule, KTY}}, ENCModule, ENC, dir) ->
	next_cek(KTYModule:derive_key(KTY), ENCModule, ENC, dir).

%%====================================================================
%% API functions
%%====================================================================

%%%-------------------------------------------------------------------
%%% Internal functions
%%%-------------------------------------------------------------------