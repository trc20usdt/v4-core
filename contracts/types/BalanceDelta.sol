// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.20;

type BalanceDelta is int256;

using {add as +, sub as -} for BalanceDelta global;
using BalanceDeltaLibrary for BalanceDelta global;

function toBalanceDelta(int128 _amount0, int128 _amount1) pure returns (BalanceDelta balanceDelta) {
    /// @solidity memory-safe-assembly
    assembly {
        balanceDelta :=
            or(shl(128, _amount0), and(0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff, _amount1))
    }
}

function noOpToBalanceDelta(bytes32 input) view returns (BalanceDelta balanceDelta) {
    int112 amt0;
    int112 amt1;
    /// @solidity memory-safe-assembly
    assembly {
        amt0 := and(0x000000000000000000000000000000000000ffffffffffffffffffffffffffff, input)
        amt1 := and(0x000000000000000000000000000000000000ffffffffffffffffffffffffffff, shr(112, input))
    }

    balanceDelta = toBalanceDelta(int128(amt0), int128(amt1));
}

function add(BalanceDelta a, BalanceDelta b) pure returns (BalanceDelta) {
    return toBalanceDelta(a.amount0() + b.amount0(), a.amount1() + b.amount1());
}

function sub(BalanceDelta a, BalanceDelta b) pure returns (BalanceDelta) {
    return toBalanceDelta(a.amount0() - b.amount0(), a.amount1() - b.amount1());
}

library BalanceDeltaLibrary {
    function amount0(BalanceDelta balanceDelta) internal pure returns (int128 _amount0) {
        /// @solidity memory-safe-assembly
        assembly {
            _amount0 := shr(128, balanceDelta)
        }
    }

    function amount1(BalanceDelta balanceDelta) internal pure returns (int128 _amount1) {
        /// @solidity memory-safe-assembly
        assembly {
            _amount1 := balanceDelta
        }
    }
}