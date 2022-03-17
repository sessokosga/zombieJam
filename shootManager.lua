--- Add a new shoot

---@param pX number
---@param pY number
---@param pVx number
---@param pVy number
---@param pRotation number
---@param pImage love.image
---@return table
local function newShoot(pX, pY, pVx, pVy, pRotation, pImage)
    local shoot = {
        x = pX,
        y = pY,
        vx = pVx,
        vy = pVy,
        rotation = pRotation,
        image = pImage
    }

    function shoot:load()

    end



    function shoot:update(dt)
        self.x = self.x + self.vx*60*dt
        self.y = self.y + self.vy*60*dt
    end

    function shoot:draw()
        love.graphics.draw(self.image, self.x, self.y, self.rotation, 1, 1, self.image:getWidth()/2,self.image:getHeight()/2)

    end
    return shoot
end

local shootManager = {
    listShoots={}
}
local zombie

--- Update shoot manager
function shootManager:load()
    self.image = love.graphics.newImage("vault/Hero/shoot.png")
end

--- Register a shoot to the shoot manager
function shootManager:addShoot(pX,pY,pVx,pVy,pRotation)
    local shoot = newShoot(pX,pY,pVx,pVy,pRotation,self.image)
    table.insert(self.listShoots,shoot)
end

--- Update the shoot manager
function shootManager:update(dt)
    for i=#self.listShoots, 1, -1 do
        local shoot = self.listShoots[i]
        shoot:update(dt)
        for z=#serviceManager.zombieManager.listZombies,1,-1 do
            zombie =serviceManager.zombieManager.listZombies[z]
            if(isColliding(shoot.x,shoot.y,self.image:getWidth(),self.image:getHeight(),zombie.x-TILEWIDTH/2,zombie.y-TILEHEIGHT/2,TILEWIDTH,TILEHEIGHT)) then
                zombie:hurt()
                table.remove(self.listShoots,i)
            end
        end
    end
end

--- Draw the shoot manager
function shootManager:draw()
    for i=1, #self.listShoots do
        self.listShoots[i]:draw()
    end
end

return shootManager
