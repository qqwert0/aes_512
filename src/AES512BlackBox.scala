package aes

import chisel3._
import chisel3.util._

class aes_cipher_512() extends BlackBox{
	val io = IO(new Bundle{
		val rst 					    = Input(Bool())
		val clk 					    = Input(Clock())

		val key					        = Input(UInt(128.W))
		val data_in_valid				= Input(UInt(1.W))
		val data_in					    = Input(UInt(512.W))
		val data_in_last				= Input(UInt(1.W))
		val data_out_valid				= Output(UInt(1.W))
        val data_out				    = Output(UInt(512.W))	
		val data_out_last				= Output(UInt(1.W))	
	})
}