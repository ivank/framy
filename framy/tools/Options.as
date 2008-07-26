package framy.tools{
	
	/**
	* A class for simple handling of optional arguments of functions
	* usage: var options:Options = new Options(opts,{ [default arguments] })
	* 
	* @author Default
	* @version 0.1
	*/
	public dynamic class Options extends Hash{
		public function Options(options:Object, defaults:Object){
			if(options == null)options = new Object()
			this.merge(new Hash(defaults).merge(options))
		}
		
		/**
		* if the options hash contains special arguments(size or dims, from..to), they are parsed to 'width' and 'height' only
		* @return
		*/
		public function parse_size():void {
			if(this.dims && !this.width && !this.height){this.width = this.dims[0]; this.height = this.dims[1]}
			if(this.size && !this.width && !this.height && !this.dims)this.width = this.height = this.size
			if(this.from && this.to && !this.width && !this.height && !this.dims){
				this.width = this.to[0] - this.from[0]
				this.height = this.to[1] - this.from[1]
			}
		}
		
		/**
		* parse the 'pos' argument array to 'x' and 'y'
		* @return
		*/
		public function parse_pos():void{
			if (this.pos && !this.from) this.from = this.pos
			if (this.pos) { this.x = this.pos[0]; this.y = this.pos[1] }
			
		}
		
	}
	
}
